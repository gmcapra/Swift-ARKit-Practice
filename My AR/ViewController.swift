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

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionObserver, UIGestureRecognizerDelegate {
    
    // outlet referencing our AR Scene View in the Main Storyboard
    @IBOutlet var sceneView: ARSCNView!
    
    // define notification label to inform user of session status
    let notificationLabel = UILabel()
    
    //define object node to be interacted with in AR
    var objectNode: SCNNode!
    
    // set current angle for rotation gestures
    var currentAngleY: Float = 0.0
    
    // set max and min scales for pinch gestures
    let maxScale: Float = 5
    let minScale: Float = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show various stats about our AR session
        sceneView.showsStatistics = true
        // enable to show various feature dots that the camera recognizes
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // initialize the scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        // set the delegate of the sceneview to self
        sceneView.delegate = self
        
        //add our notification label
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.font = UIFont(name: "Avenir", size: 15)
        notificationLabel.text = "This is a notification label"
        notificationLabel.textColor = .white
        notificationLabel.textAlignment = .left
        notificationLabel.frame = CGRect(x:20, y:50, width: 500, height: 50)
        sceneView.addSubview(notificationLabel)
        
        
        // add gestures for 3D object interaction
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            sceneView.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
            sceneView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
            panGesture.delegate = self
            sceneView.addGestureRecognizer(panGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // configure the session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        sceneView.session.run(config)
        
    }
    
    // MARK: - Object Interaction Functions

    
    @objc func didTap(_ gesture: UIPanGestureRecognizer) {
        print("user did tap")
          guard let _ = objectNode else { return }
           let tapLocation = gesture.location(in: sceneView)
           let results = sceneView.hitTest(tapLocation, types: .featurePoint)
           if let result = results.first {
               let translation = result.worldTransform.translation
               objectNode.position = SCNVector3Make(translation.x, translation.y, translation.z)
               sceneView.scene.rootNode.addChildNode(objectNode)
           }
       }
    
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        guard let _ = objectNode else { return }
        var originalScale = objectNode?.scale
        switch gesture.state {
            case .began:
                originalScale = objectNode?.scale
                gesture.scale = CGFloat((objectNode?.scale.x)!)
            case .changed:
                guard var newScale = originalScale else { return }
                if gesture.scale < CGFloat(minScale) { // too small
                    newScale = SCNVector3(x: minScale, y: minScale, z: minScale)
                }
                else if gesture.scale > CGFloat(maxScale) { // too big
                    newScale = SCNVector3(maxScale, maxScale, maxScale)
                }
                else {
                    newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
                }
                objectNode?.scale = newScale
            case .ended:
                guard var newScale = originalScale else { return }
                if gesture.scale < CGFloat(minScale) { // too small
                    newScale = SCNVector3(x: minScale, y: minScale, z: minScale)
                }
                else if gesture.scale > CGFloat(maxScale) { // too big
                    newScale = SCNVector3(maxScale, maxScale, maxScale)
                }
                else {
                    newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
                }
                objectNode?.scale = newScale
                gesture.scale = CGFloat((objectNode?.scale.x)!)
            default:
                gesture.scale = 1.0
                originalScale = nil
        }
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
           guard let _ = objectNode else { return }
           let translation = gesture.translation(in: gesture.view)
           var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
           newAngleY += currentAngleY
           objectNode?.eulerAngles.y = newAngleY
           if gesture.state == .ended{
               currentAngleY = newAngleY
           }
       }
    
     // MARK: - ARSCNView delegate
     
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            // Called when a node is added to the anchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        DispatchQueue.main.async {
                self.notificationLabel.text = "A surface has been detected."
        }
        let my3DModel = SCNScene(named: "ship.scn", inDirectory: "art.scnassets")
        objectNode = my3DModel?.rootNode.childNode(withName: "ship", recursively: true)
        objectNode.simdPosition = SIMD3<Float>(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        sceneView.scene.rootNode.addChildNode(objectNode)
        node.addChildNode(objectNode)
    }
     
     func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            // Helps when any node has been removed from the sceneview
    }
     
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            // When a node is updated with data from the anchor
    }
    
    // MARK: - ARSessionObserver

    func sessionWasInterrupted(_ session: ARSession) {
        // session has been interrupted
        print("Session was interrupted")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // reset tracking once the session is no longer interrupted
        print("session no longer interrupted, resetting tracking")
        resetTracking()
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // session failed
        print("session has failed: \(error.localizedDescription)")
        resetTracking()
    }

    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // Assists when we need to inform the user that the app is ready
        switch camera.trackingState {
             case .normal :
                 notificationLabel.text = "Please move the device to detect surfaces."
             case .notAvailable:
                 notificationLabel.text = "Tracking is currently unavailable."
             case .limited(.excessiveMotion):
                 notificationLabel.text = "Please slow down your movement."
             case .limited(.insufficientFeatures):
                 notificationLabel.text = "Please point device at an area with more surface details."
             case .limited(.initializing):
                 notificationLabel.text = "Initializing AR Session..."
             default:
                //show nothing in label
                 notificationLabel.text = ""
        }
    }

    
}

extension float4x4 {
    // get translation of world transform
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
