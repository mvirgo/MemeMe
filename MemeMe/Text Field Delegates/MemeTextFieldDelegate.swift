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
    // Set attributes of text
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.0
    ]
    
    // Clear text field if only default text included
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Exit text field when returned
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
