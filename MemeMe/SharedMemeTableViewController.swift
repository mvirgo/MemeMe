//
//  SharedMemeTableViewController.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/21/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class SharedMemeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Make sure table data is reloaded appropriately
        self.tableView.reloadData()
    }
    
    // MARK: Get memes from App Delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText

        return cell
    }
    
    // MARK: Show Meme detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SharedMemeDetailView") as! SharedMemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }
}
