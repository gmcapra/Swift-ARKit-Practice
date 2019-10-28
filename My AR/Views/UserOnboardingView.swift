//
//  UserOnboardingView.swift
//  My AR
//
//  Created by Gianluca Capraro on 10/20/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import Foundation
import UIKit

class UserOnboardingView: UIView {
    
    var arUIElements: AR_UI_Elements_
    let customerText = CustomerFacingText()
    
    // Anchors used to manipulate "swipe to exit" effect
    var onboardingLeadingAnchor: NSLayoutConstraint!
    
    // Objects
    let logo = UIImageView()
    let userSteps = UITextView()
    let back = UIButton()
    let forward = UIButton()
    
    var onboardID: Int = 0
    
    init(arUIElements: AR_UI_Elements_) {
        // Pass in the screen dimensions and color pallete from the view controller
        self.arUIElements = arUIElements
        // Initialize views frame prior to setting constraints
        super.init(frame: CGRect.zero)
    }
    
    func buildView() {
        // Miscelaneous view settings
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AR_UI_Elements_.Color.hippieRed
        // Set constraints not related to superview (ViewController)
        onboardingLeadingAnchor = leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.width),
            heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.onboardingHeight),
            onboardingLeadingAnchor
            ])
        // Set constraints related to superview (ViewController)
        if self.superview != nil {
            NSLayoutConstraint.activate([
                bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor)
                ])
        }
        
        // Add logo for first page of onboarding
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.isUserInteractionEnabled = false
        logo.image = UIImage(named: "loading_logo_white")
        
        // Define the area to display text for each step
        addSubview(userSteps)
        userSteps.translatesAutoresizingMaskIntoConstraints = false
        userSteps.isScrollEnabled = false
        userSteps.isUserInteractionEnabled = false
        userSteps.textColor = AR_UI_Elements_.Color.hippieCyan
        userSteps.textAlignment = .left
        userSteps.font = AR_UI_Elements_.Font.onboardingHeaderFont
        userSteps.backgroundColor = AR_UI_Elements_.Color.hippieRed
        userSteps.text = customerText.onboardingText[0]
        
        // Define back button for navigation backward between views
        addSubview(back)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setTitle("Back", for: .normal)
        back.setTitleColor(AR_UI_Elements_.Color.hippieCyan, for: .normal)
        back.titleLabel?.font = AR_UI_Elements_.Font.notificationLabelFont
        back.contentHorizontalAlignment = .left
        back.addTarget(self, action: #selector(navigateOnboarding), for: .touchUpInside)
        back.tag = -1
        back.isHidden = true
        
        // Define the forward (next) button to navigate forward
        addSubview(forward)
        forward.translatesAutoresizingMaskIntoConstraints = false
        forward.setTitle("Next", for: .normal)
        forward.setTitleColor(AR_UI_Elements_.Color.hippieCyan, for: .normal)
        forward.titleLabel?.font = AR_UI_Elements_.Font.notificationLabelFont
        forward.contentHorizontalAlignment = .right
        forward.addTarget(self, action: #selector(navigateOnboarding), for: .touchUpInside)
        forward.tag = 1
       
        // Activate layout constraints for UI elements
        NSLayoutConstraint.activate([
            logo.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.onboardingLogoSize),
            logo.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.onboardingLogoSize),
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            logo.topAnchor.constraint(equalTo: topAnchor),//, constant: arUIElements.leadingStatusBarSpacing),
            userSteps.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.userStepsWidth),
            userSteps.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.userStepsHeight),
            userSteps.centerXAnchor.constraint(equalTo: centerXAnchor),
            userSteps.topAnchor.constraint(equalTo: logo.bottomAnchor),
            forward.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.navOnboardingButtonSize),
            forward.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.navOnboardingButtonSize),
            forward.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AR_UI_Elements_.Sizing.onboardingSpacingToSides),
            forward.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AR_UI_Elements_.Sizing.onboardingSpacingToBottom),
            back.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.navOnboardingButtonSize),
            back.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.navOnboardingButtonSize),
            back.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AR_UI_Elements_.Sizing.onboardingSpacingToSides),
            back.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AR_UI_Elements_.Sizing.onboardingSpacingToBottom)
            ])
        
        userSteps.sizeToFit()
    }

    func animateLeadingAnchor(constant: CGFloat) {
        onboardingLeadingAnchor.constant = constant
        if constant == AR_UI_Elements_.Sizing.width {
           //
            
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()}, completion: nil)
    }
    
    @objc func navigateOnboarding(sender: UIButton) {
        // Logic for navigating between onboarding views and exiting onboarding
        onboardID += sender.tag
        if sender.tag == -1 {
            forward.setTitleColor(AR_UI_Elements_.Color.hippieCyan, for: .normal)
            self.forward.setTitle("Next", for: .normal)
        }
        if onboardID < 0 {
            // cannot be 0
            onboardID = 0
        }
        back.isHidden = false
        if onboardID == 0 {
            // hide the back button if viewing first question
            back.isHidden = true
        }
        if onboardID == customerText.onboardingText.count-1 {
            // increment to last step in onboarding
            forward.setTitleColor(AR_UI_Elements_.Color.hippieYellow, for: .normal)
            forward.setTitle("Let's go!", for: .normal)
        }
        if onboardID == customerText.onboardingText.count {
            // user hit final confirmation button
            // take user to main menu
            // store completion of onboarding
            let hapticFeedback = UINotificationFeedbackGenerator()
            hapticFeedback.notificationOccurred(.success)
            animateLeadingAnchor(constant: AR_UI_Elements_.Sizing.width)
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            print("user has now completed onboarding")
            return
        }
        // set the text to the appropriate step in onboardingText
        self.userSteps.text = self.customerText.onboardingText[onboardID]

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}

