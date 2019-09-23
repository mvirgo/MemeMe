//
//  SharedMemeTableViewController.swift
//  MemeMe
//
//  Created by Michael Virgo on 9/21/19.
//  Copyright © 2019 mvirgo. All rights reserved.
//

import UIKit

class SharedMemeTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        Helper.showMemeDetail(self.storyboard!, navigationController!,
                              memes, indexPath)
    }
}
