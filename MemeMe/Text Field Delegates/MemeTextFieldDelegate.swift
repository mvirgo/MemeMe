//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/9/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    // Clear text field if only default text included
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
