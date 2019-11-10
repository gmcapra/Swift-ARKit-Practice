//
//  DetectedPlaneNode.swift
//  My AR
//
//  Created by Gianluca Capraro on 11/3/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class DetectedPlaneNode: SCNNode {
    
    //Define the AR Plane anchor and plane geometry variables
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!
    
    /*
     * The init method:
     - Creates an SCNPlane geometry
     - Adds node generated from geometry
     */
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        // initialize anchor and geometry, set material
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = initializePlaneMaterial()
        self.planeGeometry!.materials = [material]
        
        /*
        Create a SceneKit plane
        - SceneKit planes are vertical
        - Initialize y coordinate to 0, use z coordinate
        - Rotate plane 90º.
        */
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0)
        
        // Update plane material
        updatePlaneMaterialDimensions()
        
        // add the node
        self.addChildNode(planeNode)
    }
    
    /*
    Create and initialize the material for the plane
    */
    func initializePlaneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.cyan.withAlphaComponent(0.70)
        return material
    }
    
    /*
     Update the plan when changes detected
     Note: the y and z coordinates were changed on init,
        - This needs to be taken into account when modifying the plane
    */
    func updateWithNewAnchor(_ anchor: ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        // update the position
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        // scale the plane so that it is more apparent to user
        self.scale = SCNVector3(5,1,5)
        
        // update the material for the plane
        updatePlaneMaterialDimensions()
    }
    
    /*
    This method updates the material as the plane is updated
    */
    func updatePlaneMaterialDimensions() {
        // get material
        let material = self.planeGeometry.materials.first!
        
        // scale material to the appropriate width and height
        let width = Float(self.planeGeometry.width)
        let height = Float(self.planeGeometry.height)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1.0)
    }
    
    /*
     This method adds the set animation to the detected plane. This means that
     the plane is ready and waiting to be repositioned.
     
     */
    func addAnimation() {
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.02, z: 0, duration: 2)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.02, z: 0, duration: 2)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let repeatHover = SCNAction.repeatForever(hoverSequence)
        self.runAction(repeatHover)
    }
    
    /*
     This method stops all current animations on the detected plane.
     */
    func stopAnimation() {
        self.removeAllActions()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
