//
//  ViewController.swift
//  My AR
//
//  Created by Gianluca Capraro on 9/24/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionObserver {
       
    // AR Scene Elements
    @IBOutlet var gameSceneView: ARSCNView!
    
    // Define the array of detectedPlanes
    // Every plane has own UUID
    var detectedPlanes = [UUID: DetectedPlaneNode]()
    //Only allow creation of one plane
    var planeWasCreated:Bool!
    
    // Define Views
    var userOnboardingView: UserOnboardingView!
    var mainMenuView: MainMenuView!
    var planeDetectionHUDView: PlaneDetectionHUDView!
    var adjustPlaneHUDView: AdjustPlaneHUDView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the HUD to adjust plane properties
        adjustPlaneHUDView = AdjustPlaneHUDView(arUIElements: AR_UI_Elements_())
        view.addSubview(adjustPlaneHUDView)
        adjustPlaneHUDView.buildView()
        adjustPlaneHUDView.animateLeadingAnchor(constant: -AR_UI_Elements_.Sizing.width)
        
        // Create the plane detection HUD
        planeDetectionHUDView = PlaneDetectionHUDView(arUIElements: AR_UI_Elements_())
        view.addSubview(planeDetectionHUDView)
        planeDetectionHUDView.buildView()
        planeDetectionHUDView.animateLeadingAnchor(constant: -AR_UI_Elements_.Sizing.width)
        
        // Add The Main Menu View
        mainMenuView = MainMenuView(arUIElements: AR_UI_Elements_())
        view.addSubview(mainMenuView)
        mainMenuView.buildView()
        
        // Create the onboarding view and check if needed
        userOnboardingView = UserOnboardingView(arUIElements: AR_UI_Elements_())
        if (!checkHasLaunched()) {
            view.addSubview(userOnboardingView)
            userOnboardingView.buildView()
        }
        
        ///////////////////////////////////////////////
        // Add other views here
        // 1. Need overlay for walking user through primary game plane setup
        // 2. Additional view to add...
        // 3. Additional view to add...
        // 4. Additional view to add...
        //
        //
        ///////////////////////////////////////////////
        
        // Add the AR Scene
        setupARScene()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         // Setup the ar session but dont look for planes yet
         configureARSession(detectPlanes: false)
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         // Pause the view's session
         gameSceneView.session.pause()
     }
    
    func checkHasLaunched()->Bool {
        // Function to check if the app has been previously run on the device
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        print("hasLaunchedBefore: \(hasLaunched)")
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            print("user has not completed onboarding")
            return false
        }
        else {
            print("returning user")
            return true
        }
    }
    
    func setupARScene() {
        // enable to show feature dots that the camera recognizes
        gameSceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // initialize the scene
        let scene = SCNScene()
        gameSceneView.scene = scene
        // set the delegate of the sceneview to self
        gameSceneView.delegate = self
        planeWasCreated = false
    }
    
    func configureARSession(detectPlanes: Bool) {
        // configure the AR session and check for plane detection
        let config = ARWorldTrackingConfiguration()
        if detectPlanes {
            config.planeDetection = .horizontal
        } else {
            config.planeDetection = []
        }
        gameSceneView.session.run(config)
    }
    
    func startDetection() {
        // User tapped the Start Button.
        print("starting plane detection, adding horizontal plane detection")
        // Move the plane detection HUD in
        planeDetectionHUDView.animateLeadingAnchor(constant: 0)
        // Start detecting and showing planes
        configureARSession(detectPlanes: true)
        
        // After a tap, add a rocket model to the scene
        // addTapGestureToARSceneView()
    }
    
    func addTapGestureToARSceneView() {
        // Enable the tap gesture recognizer in the AR Scene View
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addObjectToARSceneView(withGestureRecognizer:)))
        gameSceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func stopDetectingPlanes() {
        //if we have a valid plane, the user taps to stop updating
        print("stopping plane detection, allow user to edit plane properties")
        planeWasCreated = true
        planeDetectionHUDView.animateLeadingAnchor(constant: -AR_UI_Elements_.Sizing.width)
        adjustPlaneHUDView.animateLeadingAnchor(constant: 0)
        configureARSession(detectPlanes: false)
    }
    
    
    /*
     This method can be called as a tap gesture. When called, this method
     adds a 3d model of a rocket to the scene.
     */
    @objc func addObjectToARSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        print("tap")
        let tapLocation = recognizer.location(in: gameSceneView)
        let hitTestResults = gameSceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        guard let shipScene = SCNScene(named: "ship.scn"),
            let shipNode = shipScene.rootNode.childNode(withName: "Rocket", recursively: false)
            else { return }
        
        shipNode.position = SCNVector3(x,y,z)
        shipNode.scale = SCNVector3(0.5,0.5,0.5)
        gameSceneView.scene.rootNode.addChildNode(shipNode)
    }
    
}

// MARK: - AR Session Delegate

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard
            let error = error as? ARError,
            let code = ARError.Code(rawValue: error.errorCode)
            else { return }
        switch code {
        case .cameraUnauthorized:
            self.planeDetectionHUDView.informationLabel.text = "Camera tracking is not available. Please check your camera permissions."
        default:
            self.planeDetectionHUDView.informationLabel.text = "Error starting ARKit. Please try to relaunch the app."
        }
  }

  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    switch camera.trackingState {
    case .limited(let reason):
      switch reason {
        case .excessiveMotion:
            self.planeDetectionHUDView.informationLabel.text = "Camera is moving too fast!"
        case .initializing, .relocalizing:
            self.planeDetectionHUDView.informationLabel.text = "ARKit is loading.\nMove the camera around to speed up calibration."
        case .insufficientFeatures:
            self.planeDetectionHUDView.informationLabel.text = "Move the camera around or adjust the light in your environment."
        @unknown default:
            print("default unknown")
        }
    case .normal:
        self.planeDetectionHUDView.informationLabel.text = "Searching for level surfaces..."
    case .notAvailable:
        self.planeDetectionHUDView.informationLabel.text = "Camera tracking unavailable."
        }
    
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // create a 3d plane from given anchor
        if let arPlaneAnchor = anchor as? ARPlaneAnchor {
           if (!planeWasCreated) {
                let plane = DetectedPlaneNode(anchor: arPlaneAnchor)
                self.detectedPlanes[arPlaneAnchor.identifier] = plane
                // only add the plane if one doesn't exist
                planeWasCreated = true
                node.addChildNode(plane)
                plane.addAnimation()
                DispatchQueue.main.async {
                    self.planeDetectionHUDView.informationLabel.text = "Plane Detected."
                    self.stopDetectingPlanes()
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = detectedPlanes[arPlaneAnchor.identifier] {
            plane.position = SCNVector3(arPlaneAnchor.center.x, 0, arPlaneAnchor.center.z)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = detectedPlanes.index(forKey: arPlaneAnchor.identifier) {
            detectedPlanes.remove(at: index)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Present overlay informing user session was interrupted
    }
    
}

extension float4x4 {
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
