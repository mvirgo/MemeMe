//
//  SharedMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/21/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class SharedMemeCollectionViewController: UICollectionViewController {
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure view respects the safe area
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        setFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Make sure collection data is reloaded appropriately
        self.collectionView.reloadData()
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

    // MARK: Show Meme detail view
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SharedMemeDetailView") as! SharedMemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: Handle device rotations to re-calculate flow layout
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setFlowLayout()
    }
    
    // MARK: Function to handle flow layout
    func setFlowLayout() {
        let space:CGFloat = 3.0
        let divisor: CGFloat
        if UIDevice.current.orientation.isPortrait {
            divisor = 2.0
        } else {
            divisor = 3.0
        }
        let dimension = (view.safeAreaLayoutGuide.layoutFrame.width - (2 * space)) / divisor
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
