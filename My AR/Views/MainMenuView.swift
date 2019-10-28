//
//  MainMenuView.swift
//  My AR
//
//  Created by Gianluca Capraro on 10/20/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import Foundation
import UIKit

class MainMenuView: UIView {
    
    var arUIElements: AR_UI_Elements_
    
    // Anchors used to manipulate "swipe to exit" effect
    var mainMenuLeadingAnchor: NSLayoutConstraint!
    
    // Objects
    let mainImage = UIImageView()
    let playButton = UIButton()
    let gameCenterButton = UIButton()
        
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
        mainMenuLeadingAnchor = leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.width),
            heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.height),
            mainMenuLeadingAnchor
            ])
        // Set constraints related to superview (ViewController)
        if self.superview != nil {
            NSLayoutConstraint.activate([
                bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor)
                ])
        }

        // Add image for main menu
        addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.isUserInteractionEnabled = false
        mainImage.image = UIImage(named: "invadeARtestLogo")
    
        // Create menu items
        addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setBackgroundImage(UIImage(named: "playButton"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playButton.isHidden = false
        
        addSubview(gameCenterButton)
        gameCenterButton.translatesAutoresizingMaskIntoConstraints = false
        gameCenterButton.setBackgroundImage(UIImage(named: "gameCenterButton"), for: .normal)
        //forward.addTarget(self, action: #selector(navigateOnboarding), for: .touchUpInside)
        gameCenterButton.isHidden = false
        
        // Activate constraints for menu items
        NSLayoutConstraint.activate([
            mainImage.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.mainImageWidth),
            mainImage.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.mainImageHeight),
            mainImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainImage.topAnchor.constraint(equalTo: topAnchor, constant: AR_UI_Elements_.Sizing.mainImageToTop),
            playButton.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.playButtonWidth),
            playButton.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.playButtonHeight),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            gameCenterButton.widthAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.gameCenterButtonSize),
            gameCenterButton.heightAnchor.constraint(equalToConstant: AR_UI_Elements_.Sizing.gameCenterButtonSize),
            gameCenterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            gameCenterButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: AR_UI_Elements_.Sizing.playButtonToBottomButtons)
            ])
    }
    
    @objc func playButtonTapped() {
        // Remove the main menu and alert the vc to start the game
        animateLeadingAnchor(constant: AR_UI_Elements_.Sizing.width)
        if let vc = self.window!.rootViewController as? ViewController {
            vc.startGame()
        }
    }

    func animateLeadingAnchor(constant: CGFloat) {
        mainMenuLeadingAnchor.constant = constant
        if constant == AR_UI_Elements_.Sizing.width {
           //
            
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {self.superview!.layoutIfNeeded()}, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
}
