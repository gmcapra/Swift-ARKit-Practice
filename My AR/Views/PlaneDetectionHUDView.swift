//
//  PlaneDetectionHUDView.swift
//  My AR
//
//  Created by Gianluca Capraro on 11/9/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import Foundation
import UIKit

class PlaneDetectionHUDView: UIView {
    
    var arUIElements: AR_UI_Elements_
    
    // Anchors used to manipulate "swipe to exit" effect
    var planeDetectionHUDLeadingAnchor: NSLayoutConstraint!
    
    // Objects
    let informationLabel = UILabel()
    let informationLabel2 = UILabel()
    let rescanButton = UIButton()

        
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
        planeDetectionHUDLeadingAnchor = leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.width),
            heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.height),
            planeDetectionHUDLeadingAnchor
            ])
        // Set constraints related to superview (ViewController)
        if self.superview != nil {
            NSLayoutConstraint.activate([
                bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor)
                ])
        }
        
        // Add information label to inform user on steps
        addSubview(informationLabel)
        informationLabel.isHidden = false
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.isUserInteractionEnabled = false
        informationLabel.font = AR_UI_Elements_.Font.informationLabelFont
        informationLabel.text = ""
        informationLabel.numberOfLines = 0
        informationLabel.textAlignment = .center
        informationLabel.textColor = .white
        
        // Add second information label to inform user on steps
        addSubview(informationLabel2)
        informationLabel2.isHidden = false
        informationLabel2.translatesAutoresizingMaskIntoConstraints = false
        informationLabel2.isUserInteractionEnabled = false
        informationLabel2.font = AR_UI_Elements_.Font.secondaryInformationLabelFont
        informationLabel2.text = "Move the camera around to speed up calibration. After detection, tap the screen to confirm and begin editing the plane."
        informationLabel2.numberOfLines = 0
        informationLabel2.textAlignment = .center
        informationLabel2.textColor = .white
        
        // Activate constraints for menu items
        NSLayoutConstraint.activate([
            informationLabel2.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelWidth),
            informationLabel2.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelHeight),
            informationLabel2.centerXAnchor.constraint(equalTo: centerXAnchor),
            informationLabel2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AR_UI_Elements_.Sizing.width/10),
            informationLabel.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelWidth),
            informationLabel.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelHeight),
            informationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: informationLabel2.topAnchor, constant: 0)
            ])
    }
    

    func animateLeadingAnchor(constant: CGFloat) {
        planeDetectionHUDLeadingAnchor.constant = constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()}, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
