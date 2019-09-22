//
//  SharedMemeHelpers.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/22/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class Helper {
    static func showMemeDetail(_ storyboard: UIStoryboard,
                               _ navigation: UINavigationController,
                               _ memes: [Meme],
                               _ indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = storyboard.instantiateViewController(withIdentifier: "SharedMemeDetailView") as! SharedMemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigation.pushViewController(detailController, animated: true)
    }
}
