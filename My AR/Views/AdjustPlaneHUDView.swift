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
    
    // Objects
    let infoLabel = UILabel()

        
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
        
        // Add information label to inform user on steps
        addSubview(infoLabel)
        infoLabel.isHidden = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.isUserInteractionEnabled = false
        infoLabel.font = AR_UI_Elements_.Font.informationLabelFont
        infoLabel.text = "Plane Detected"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.textColor = .green
        
        // Activate constraints for menu items
        NSLayoutConstraint.activate([
            infoLabel.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelWidth),
            infoLabel.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.informationLabelHeight),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AR_UI_Elements_.Sizing.width/10)
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
