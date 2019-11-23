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
    var rotateYSlider: UISlider!
    var rotateZSlider: UISlider!
    
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
    

    func animateLeadingAnchor(constant: CGFloat) {
        adjustPlaneHUDViewLeadingAnchor.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()}, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
