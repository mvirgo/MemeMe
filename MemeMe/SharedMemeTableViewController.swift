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
    
    // TODO: Implement didSelectRowAt
    //override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //return
    //}
}
