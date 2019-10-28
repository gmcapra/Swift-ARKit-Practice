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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        // configure the AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        gameSceneView.session.run(config)
    }
    
    func startGame() {
        // User tapped the Play Button.
        print("starting game set up")
        addTapGestureToARSceneView()
        
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        /*
         HORIZONTAL PLANE DETECTED
         - Once enough feature points are detected, they indicate the presence of a horizontal plane.
         - This function is called whenever that threshold is reached and a horizontal plane is detected.
         */
        // unwrap the anchor argument as an ARPlaneAnchor to make sure we have information about a real world flat surface
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // create an SCNPlane to visualize the ARPlaneAnchor.
        // A SCNPlane is a rectangular “one-sided” plane geometry.
        // Take the unwrapped ARPlaneAnchor extents x and z properties and use them to create an SCNPlane
        // An ARPlaneAnchor extent is the estimated size of the detected plane in the world.
        // Then, we can get the extent x and z for the corresponding height and width of our SCNPlane
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        // set color properties
        plane.materials.first?.diffuse.contents = UIColor.blue
        // initialize a SCNNode with the SCNPlane geometry we just created
        let planeNode = SCNNode(geometry: plane)
        // initialize x, y, z to represent planeAnchor center x, y, z position.
        // rotate planeNode x euler angle 90 degrees counter-clockwise
        // this prevents the planeNode from sitting up perpendicular
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        node.addChildNode(planeNode)
    }
    

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        /*
        UPDATE THE DETECTED PLANE
        - Called whenever a SceneKit node's properties have been updated to match its corresponding anchor.
        - An example of how ARKit refines its estimation of the horizontal plane position and extent.
        - The node argument represents the updated position of the anchor.
        - The anchor argument provides the anchor’s updated width and height
        - Using these two, we can update previously implemented SCNPlanes to reflect a new position with the updated width and height.
        */
        // Unwrap the anchor argument as ARPlaneAnchor
        // Then, unwrap the node’s first child node
        // Finally, unwrap the planeNode’s geometry as an SCNPlane
        // In essence, this process extracts the implemented ARPlaneAnchor, SCNNode, and SCNplane and updates the properties with corresponding arguments.
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
         
        // Update the plane’s width and height using the planeAnchor extent’s x and z properties
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
         
        // Update the planeNode’s position to the planeAnchor’s center x, y, and z coordinates.
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        
    }
    
    
    
    
}
    
extension float4x4 {
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
