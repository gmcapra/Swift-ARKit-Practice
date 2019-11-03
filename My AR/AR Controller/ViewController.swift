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
        
    @IBOutlet var gameSceneView: ARSCNView!
   
    // Define Views
    var userOnboardingView: UserOnboardingView!
    var mainMenuView: MainMenuView!

    // Define the array of detected detectedPlanes where every plane has own UUID
    var detectedPlanes = [UUID: DetectedPlaneNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add The Main Menu View
        mainMenuView = MainMenuView(arUIElements: AR_UI_Elements_())
        view.addSubview(mainMenuView)
        mainMenuView.buildView()
        
        // Create the onboarding view and check if needed
        userOnboardingView = UserOnboardingView(arUIElements: AR_UI_Elements_())
        checkHasLaunched()
        
        ///////////////////////////////////////////////
        // Add other views here
        //
        //
        ///////////////////////////////////////////////
        
        // Add the AR Scene
        setupARScene()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         configureARSession()
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         // Pause the view's session
         gameSceneView.session.pause()
     }
    
    func checkHasLaunched() {
        // Function to check if the app has been previously run on the device
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        print("hasLaunchedBefore: \(hasLaunched)")
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            // first run on this device, onboard the user
            print("adding user onboarding")
            view.addSubview(userOnboardingView)
            userOnboardingView.buildView()
        }
        else {
            // not the first run on this device
            print("not the first run")
        }
    }
    
    func setupARScene() {
        // show various stats about our AR session
        gameSceneView.showsStatistics = true
        // enable to show feature dots that the camera recognizes
        gameSceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // initialize the scene
        let scene = SCNScene()
        gameSceneView.scene = scene
        // set the delegate of the sceneview to self
        gameSceneView.delegate = self
        
    }
    
    func configureARSession() {
        
        // configure the AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        gameSceneView.session.run(config)
        
    }
    
    func startGame() {
        
        // User tapped the Start Button.
        print("starting game set up, adding AR scene")
        
        //This function recognizes a tap and adds a ship scn node
        //addTapGestureToARSceneView()
        
    }
    
    
    
    
    // MARK: Augmented Reality Plane Detection, Updates, and Gesture Recognition
    
    func addTapGestureToARSceneView() {
        // Enable the tap gesture recognizer in the AR Scene View
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addObjectToARSceneView(withGestureRecognizer:)))
        gameSceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addLightingEffects() {
        // Enable lighting effects in the AR Scene View
        gameSceneView.autoenablesDefaultLighting = true
        gameSceneView.automaticallyUpdatesLighting = true
    }
    
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
            let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
            else { return }
        
        shipNode.position = SCNVector3(x,y,z)
        shipNode.scale = SCNVector3(0.5,0.5,0.5)
        gameSceneView.scene.rootNode.addChildNode(shipNode)
    }
    
        // MARK: - ARSCNViewDelegate
        
    /*
    // This can be overidden tocreate and configure nodes as anchors are added to the session
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let node = SCNNode()
            return node
        }
    */
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            // create a 3d plane from given anchor
            if let arPlaneAnchor = anchor as? ARPlaneAnchor {
                let plane = DetectedPlaneNode(anchor: arPlaneAnchor)
                self.detectedPlanes[arPlaneAnchor.identifier] = plane
                node.addChildNode(plane)
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = detectedPlanes[arPlaneAnchor.identifier] {
                plane.updateWithNewAnchor(arPlaneAnchor)
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = detectedPlanes.index(forKey: arPlaneAnchor.identifier) {
                detectedPlanes.remove(at: index)
            }
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            // Present error message to user
            
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
