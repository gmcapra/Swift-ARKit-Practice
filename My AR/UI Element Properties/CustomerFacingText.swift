//
//  CustomerFacingText.swift
//  My AR
//
//  Created by Gianluca Capraro on 10/20/19.
//  Copyright © 2019 toggle. All rights reserved.
//

import Foundation
import UIKit

struct CustomerFacingText {
    
    let textTypeToPresent =
        
        [
            "textType1" :
                [
                    "What is your first name?",
                    "Last name?",
                    "Etc.,etc.,etc...."
            ],
            "textType2" :
                [
                    "New highscore",
                    "Look out behind you!",
                    "Etc.,etc.,etc...."
            ]
    ]
    
    let onboardingText = [
       "Welcome to this Augmented Reality game by Toggle.",
       "Be aware of your surroundings when playing this game.",
       "Have fun!"
    ]
    
    init() {
        print("loaded customer facing text")
    }
    
}
