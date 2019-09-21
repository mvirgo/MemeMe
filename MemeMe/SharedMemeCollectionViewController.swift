//
//  SharedMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/21/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class SharedMemeCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Get memes from App Delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeItem", for: indexPath) as! SharedMemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the image in the cell
        cell.memeImage?.image = meme.memedImage
    
        return cell
    }

    //TODO: Implement didSelectItemAt
    //override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //return
    //}
}
