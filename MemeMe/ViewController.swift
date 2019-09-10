//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/8/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextConstraint: NSLayoutConstraint!
    
    // MARK: Text Field Delegate objects
    let memeTextDelegate = MemeTextFieldDelegate()
    
    // MARK: View functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Set up initial text fields
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.delegate = memeTextDelegate
        topTextField.defaultTextAttributes = memeTextDelegate.memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = memeTextDelegate
        bottomTextField.defaultTextAttributes = memeTextDelegate.memeTextAttributes
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // If there's an image, calculate and set the text
        if let image = imagePickerView.image {
            setImageText(image)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: UIImagePicker Delegate functions
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Set the image into the view
            imagePickerView.image = image
            // Set the image text
            setImageText(image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Image Text helper functions
    func setImageText(_ image: UIImage) {
        // Get the image dimensions and scale
        let imageViewHeight = imagePickerView.bounds.height
        let imageViewWidth = imagePickerView.bounds.width
        let imageHeight = imagePickerView.intrinsicContentSize.height
        let imageWidth = imagePickerView.intrinsicContentSize.width
        var scale: CGFloat = 0.0
        if UIDevice.current.orientation.isPortrait {
            scale = imageViewWidth / imageWidth
        } else {
            scale = imageViewHeight / imageHeight
        }
        let middle = imageViewHeight / 2
        // Move the meme text onto the image
        topTextConstraint.constant = middle - (scale * (imageHeight / 2))
        bottomTextConstraint.constant = middle - (scale * (imageHeight / 2))
    }
    
    // MARK: Keyboard functions to avoid overlaying onto text
    // Keyboard functions are from Udacity classroom
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    // MARK: Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
}

