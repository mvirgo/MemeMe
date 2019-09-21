//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/8/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
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
    
    // MARK: Meme to hold current information
    var topText: String = ""
    var bottomText: String = ""
    var originalImage: UIImage!
    var memedImage: UIImage!
    var imageHeight: CGFloat = 0.0
    var imageWidth: CGFloat = 0.0
    var scale: CGFloat = 0.0
    
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
        // Disable the activity button until an image is selected
        activityButton.isEnabled = false
        // Set up initial text fields
        setInitialText(textField: topTextField, "TOP")
        setInitialText(textField: bottomTextField, "BOTTOM")
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
            activityButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper functions to get and adjust initial text attributes
    func getAttributes() -> [NSAttributedString.Key : Any] {
        var attributes = memeTextDelegate.memeTextAttributes
        // Add centering style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributes.merge([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                         uniquingKeysWith: { (current, _) in current })
        
        return attributes
    }
    
    func setInitialText(textField: UITextField, _ initText: String) {
        let attributes = getAttributes()
        textField.text = initText
        textField.delegate = memeTextDelegate
        textField.defaultTextAttributes = attributes
    }
    
    // MARK: Image Text helper functions
    func setImageText(_ image: UIImage) {
        // Get the image dimensions and scale
        let imageViewHeight = imagePickerView.bounds.height
        let imageViewWidth = imagePickerView.bounds.width
        imageHeight = imagePickerView.intrinsicContentSize.height
        imageWidth = imagePickerView.intrinsicContentSize.width
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
        // Re-enable sharing button
        activityButton.isEnabled = true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // Hide the bottom toolbar from view
        bottomToolbar.isHidden = true
        // Disable sharing so cursor isn't accidentally visible when shared/saved
        activityButton.isEnabled = false
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
        // Create graphics context and image view to draw in, with original image size
        UIGraphicsBeginImageContext(imagePickerView.intrinsicContentSize)
        let imageView = CGRect(x: 0.0, y: 0.0,
                               width: imageWidth, height: imageHeight)
        
        // Add the image itself first
        imagePickerView.image!.draw(in: imageView)
        
        // Get and update text attributes to size to full image
        var attributes = getAttributes()
        let newSize = topTextField.font!.pointSize / scale
        attributes.updateValue(
            UIFont(name: "HelveticaNeue-CondensedBlack", size: newSize)!,
            forKey: NSAttributedString.Key.font)
        
        // Add top and bottom text
        let topText = topTextField.text! as NSString
        topText.draw(in: imageView.offsetBy(dx: 0, dy: imageHeight * 0.1),
                     withAttributes: attributes)
        let bottomText = bottomTextField.text! as NSString
        bottomText.draw(in: imageView.offsetBy(dx: 0, dy: imageHeight * 0.9 - newSize),
                        withAttributes: attributes)
        
        // Create the meme image & end the graphics context
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func save() {
        // Store meme information
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,
                        originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: Function to return to root page
    func returnToInitialView() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

    // MARK: Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(.camera)
    }
    
    func pickAnImage(_ type: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareAndSaveMeme(_ sender: Any) {
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage],
                                                  applicationActivities: nil)
        // Handle iPads
        if let popup = controller.popoverPresentationController {
            popup.barButtonItem = activityButton
        }
        // Present the activity view
        present(controller, animated: true, completion: nil)
        // Save the image if selected
        controller.completionWithItemsHandler = {(activity, success, items, error) in
            if success {
                self.save()
                self.returnToInitialView()
            }
        }
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        // Set back to root view
        self.returnToInitialView()
    }
}

