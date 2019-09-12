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

    // MARK: Constants
    let textPositionScale: CGFloat = 0.9
    let keyboardViewPositionScale: CGFloat = 0.9
    
    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Text Field Delegate objects
    let memeTextDelegate = MemeTextFieldDelegate()
    
    // MARK: View functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable camera button only if there is a camera available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Disable the activity & cancel buttons until an image is selected
        activityButton.isEnabled = false
        cancelButton.isEnabled = false
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
            // Enable the activity button for sharing/saving
            //   as well as the cancel button
            activityButton.isEnabled = true
            cancelButton.isEnabled = true
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
        // Calculate image scale based on device orientation
        if UIDevice.current.orientation.isPortrait {
            scale = imageViewWidth / imageWidth
        } else {
            scale = imageViewHeight / imageHeight
        }
        let middle = imageViewHeight / 2
        // Move the meme text onto the image
        // Multiply by textPositionScale to move slightly into image
        topTextConstraint.constant =
            middle - (scale * (imageHeight / 2) * textPositionScale)
        bottomTextConstraint.constant =
            middle - (scale * (imageHeight / 2) * textPositionScale)
    }
    
    // MARK: Keyboard functions to avoid overlaying onto text
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
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        // Set frame back to normal
        view.frame.origin.y = 0
        // Make sure bottom toolbar is shown
        bottomToolbar.isHidden = false
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // Hide the bottom toolbar from view
        bottomToolbar.isHidden = true
        // If editing bottom text, move up view by percent of keyboard height
        // keyboardViewPositionScale used as small screens might push above
        //   safe space otherwise
        if bottomTextField.isEditing {
            view.frame.origin.y =
                -getKeyboardHeight(notification) * keyboardViewPositionScale
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Functions to store memes
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        return memedImage
    }
    
    func save() {
        // Create meme
        let memedImage = generateMemedImage()
        // Save image
        UIImageWriteToSavedPhotosAlbum(memedImage, self, nil, nil)
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
    
    @IBAction func shareOrSaveMeme(_ sender: Any) {
        let meme = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    @IBAction func cancelMeme(_ sender: Any) {
        // Set back to initial view
        imagePickerView.image = nil
        viewDidLoad()
    }
}

