//
//  ButtonStyleManager.swift
//  ImageRecognitionApp
//
//  Created by Tristan Wolf on 2017-07-08.
//  Copyright © 2017 Tristan Wolf. All rights reserved.
//

import Foundation
import UIKit

class ButtonStyleManager: UIButton {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
}
