//
//  AR_UI_Elements.swift
//  My AR
//
//  Created by Gianluca Capraro on 10/20/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import Foundation
import UIKit

struct AR_UI_Elements_ {
        
    // Define specificsize ratios is needed
    static let headerRatio: CGFloat = 0.07
    static let remainingUIRatio: CGFloat = 0.93
    
    struct Sizing {
        
        // Get key screen dimensions
        static let bounds = UIScreen.main.bounds
        static let statusBar = UIApplication.shared.statusBarFrame.size
        static let statusBarHeight = statusBar.height
        static let objectPadding = statusBar.height/2
        static let height = bounds.height - statusBarHeight
        static let width = bounds.width
        static let widthObjectPadding = width-statusBar.height
        static let widthStatusBarSpacing = width - statusBarHeight
        static let leadingStatusBarSpacing = statusBarHeight/2
        
        // Onboarding Sizes
        static let onboardingHeight = height
        static let onboardingLogoSize = onboardingHeight/4
        static let userStepsWidth = width - width/5
        static let userStepsHeight = onboardingHeight/2
        static let navOnboardingButtonSize = width/5
        static let onboardingSpacingToSides = width/10
        static let onboardingSpacingToBottom = height/12
        
        // Main Menu Sizes
        static let mainImageWidth = height/3
        static let mainImageHeight = height/4
        static let mainImageToTop = height/8
        static let playButtonWidth = height/3
        static let playButtonHeight = height/4
        static let playButtonToMainImage = height/8
        static let playButtonToBottomButtons = height/8
        static let gameCenterButtonSize = height/10
        
        
    }

    // fonts
    struct Font {
        static let notificationFont = "Helvetica"
        static let notificationLabelFont = UIFont(name: notificationFont, size: 20)
        
        static let onboardingFont = "Helvetica"
        static let onboardingHeaderFont = UIFont(name: onboardingFont, size: 30)
        
        static let playButtonFontName = "Helvetica"
        static let playButtonFont = UIFont(name: playButtonFontName, size: 40)

    }
    
    // colors
    struct Color {
        
        //HippieRainbow Colors
        static let hippieBlue = UIColor(displayP3Red: 30/255, green: 56/255, blue: 136/255, alpha: 1.0)
        static let hippieCyan = UIColor(displayP3Red: 71/255, green: 168/255, blue: 189/255, alpha: 1.0)
        static let hippieYellow = UIColor(displayP3Red: 245/255, green: 230/255, blue: 99/255, alpha: 1.0)
        static let hippieOrange = UIColor(displayP3Red: 255/255, green: 173/255, blue: 105/255, alpha: 1.0)
        static let hippieRed = UIColor(displayP3Red: 156/255, green: 56/255, blue: 72/255, alpha: 1.0)

        
        
    }
    
    static func setUI() {
        //Color definitions
        // The website https://coolors.co/ is a cool tool to find colors that maintain a consistent scheme
        // Adjust a color it starts you with to match the RGB values above, lock it, hit space bar and watch the suggested matches autopopulate
 
        print("CointactsUI | screenHeight: \(Sizing.height), screenWidth: \(Sizing.width)")
    }
    
}
