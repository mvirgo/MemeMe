//
//  SharedMemeDetailViewController.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/21/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class SharedMemeDetailViewController: UIViewController {

    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var editToolbar: UINavigationBar!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeView!.image = meme.memedImage
    }
    
    // MARK: Actions
    
    @IBAction func editMeme(_ sender: Any) {
        // Get the Meme Editor controller
        let editController = self.storyboard!.instantiateViewController(withIdentifier: "EditMemeController") as! MemeViewController
        
        // Load the current meme into the Meme Editor
        editController.topText = meme.topText
        editController.bottomText = meme.bottomText
        editController.originalImage = meme.originalImage
        editController.existingMeme = true
        
        // Present the view controller using navigation
        navigationController!.pushViewController(editController, animated: true)
    }
    
}
