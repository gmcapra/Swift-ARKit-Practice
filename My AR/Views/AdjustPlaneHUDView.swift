//
//  AdjustPlaneHUDView.swift
//  My AR
//
//  Created by Gianluca Capraro on 11/9/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import Foundation
import UIKit

class AdjustPlaneHUDView: UIView {
    
    var arUIElements: AR_UI_Elements_
    
    // Anchors used to manipulate "swipe to exit" effect
    var adjustPlaneHUDViewLeadingAnchor: NSLayoutConstraint!
    
    // Define the sliders
    var zRotationSlider: UISlider!
    var zPositionSlider: UISlider!
    
    // Objects
    let infoLabelTop = UILabel()
    let infoLabelBottom = UILabel()

        
    init(arUIElements: AR_UI_Elements_) {
        // Pass in the screen dimensions and color pallete from the view controller
        self.arUIElements = arUIElements
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func buildView() {
        // Miscelaneous view settings
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        // Set constraints not related to superview (ViewController)
        adjustPlaneHUDViewLeadingAnchor = leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.width),
            heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.height),
            adjustPlaneHUDViewLeadingAnchor
            ])
        // Set constraints related to superview (ViewController)
        if self.superview != nil {
            NSLayoutConstraint.activate([
                bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor)
                ])
        }
        
        zRotationSlider = UISlider(frame: CGRect(x: 0, y: 8*AR_UI_Elements_.Sizing.height/10, width: AR_UI_Elements_.Sizing.width, height: 20))
        zRotationSlider.tag = 1
        zRotationSlider.isHidden = true
        zRotationSlider.minimumValue = 0
        zRotationSlider.maximumValue = 360
        zRotationSlider.isContinuous = true
        zRotationSlider.tintColor = UIColor.yellow
        zRotationSlider.addTarget(self, action: #selector(AdjustPlaneHUDView.sliderValueDidChange(_:)), for: .valueChanged)
        addSubview(zRotationSlider)
        
        zPositionSlider = UISlider(frame: CGRect(x: 0, y: 7*AR_UI_Elements_.Sizing.height/10, width: AR_UI_Elements_.Sizing.width, height: 20))
        zPositionSlider.tag = 2
        zPositionSlider.isHidden = true
        zPositionSlider.minimumValue = -10
        zPositionSlider.maximumValue = 10
        zPositionSlider.isContinuous = true
        zPositionSlider.tintColor = UIColor.green
        zPositionSlider.addTarget(self, action: #selector(AdjustPlaneHUDView.sliderValueDidChange(_:)), for: .valueChanged)
        addSubview(zPositionSlider)

        // Add information label to inform user plane was detected
        addSubview(infoLabelTop)
        infoLabelTop.isHidden = false
        infoLabelTop.translatesAutoresizingMaskIntoConstraints = false
        infoLabelTop.isUserInteractionEnabled = false
        infoLabelTop.font = AR_UI_Elements_.Font.informationLabelFont
        infoLabelTop.text = "Plane Detected"
        infoLabelTop.numberOfLines = 0
        infoLabelTop.textAlignment = .center
        infoLabelTop.textColor = .green
        
        // Add information label to inform user on steps to take
        addSubview(infoLabelBottom)
        infoLabelBottom.isHidden = false
        infoLabelBottom.translatesAutoresizingMaskIntoConstraints = false
        infoLabelBottom.isUserInteractionEnabled = false
        infoLabelBottom.font = AR_UI_Elements_.Font.secondaryInformationLabelFont
        infoLabelBottom.text = "Pinch to scale the plane, swipe across the screen to adjust rotation."
        infoLabelBottom.numberOfLines = 0
        infoLabelBottom.textAlignment = .center
        infoLabelBottom.textColor = .white
        
        // Activate constraints for menu items
        NSLayoutConstraint.activate([
            infoLabelTop.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelWidth),
            infoLabelTop.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelHeight),
            infoLabelTop.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabelTop.topAnchor.constraint(equalTo: topAnchor, constant: AR_UI_Elements_.Sizing.width/8),
            infoLabelBottom.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelWidth),
            infoLabelBottom.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelHeight),
            infoLabelBottom.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabelBottom.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AR_UI_Elements_.Sizing.width/10)
            ])
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        infoLabelTop.isHidden = true
        if let vc = self.window!.rootViewController as? ViewController {
            // Snap to values step by step
            let roundedStepValue = round(sender.value / 5) * 5
            sender.value = roundedStepValue
            print("Slider value \(Int(roundedStepValue))")
            if sender.tag == 1 {
                // Handle Z rotation
                print("z rotation")
                //vc.updateZRotation(sliderAngleZ: roundedStepValue)
            }
            else if sender.tag == 2 {
                // Handle Z position
                print("z position")
                vc.updateZPosition(sliderPosZ: roundedStepValue)
            }
            print("Slider z rotation value changed")
        }
    }

    func animateLeadingAnchor(constant: CGFloat) {
        adjustPlaneHUDViewLeadingAnchor.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()}, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
