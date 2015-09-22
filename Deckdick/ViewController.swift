//
//  ViewController.swift
//  Deckdick
//
//  Created by Jonathan Wight on 9/22/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var enabledSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let userDefaults = NSUserDefaults(suiteName: "group.io.schwa.DeckDick") else {
            print("Could not load app group")
            return
        }
        enabledSwitch.on = userDefaults.boolForKey("enabled")
    }

    @IBAction func reloadContentBlocker() {
        let url = NSURL(string:"https://schwa.github.io/DeckDick/rules/BlockerList.json")!
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url) {
            (url, response, error) in
            guard let sourceURL = url else {
                print("No url: \(error)")
                return
            }

            let groupDirectoryURL = NSFileManager().containerURLForSecurityApplicationGroupIdentifier("group.io.schwa.DeckDick")

            let destinationURL = groupDirectoryURL?.URLByAppendingPathComponent("BlockerList.json")
            print(destinationURL!)

            if destinationURL!.checkResourceIsReachableAndReturnError(nil) {
                print(try? NSFileManager().removeItemAtURL(destinationURL!))
            }

            try! NSFileManager().moveItemAtURL(sourceURL, toURL: destinationURL!)
        }
    

        task.resume()
    }

    @IBAction func openSampleSite(sender:UIButton) {
        let url = NSURL(string:sender.titleForState(.Normal)!)!
        UIApplication.sharedApplication().openURL(url)
    }

    @IBAction func toggleEnabled(enabledSwitch: UISwitch) {
        let userDefaults = NSUserDefaults(suiteName: "group.io.schwa.DeckDick")!
        userDefaults.setBool(enabledSwitch.on, forKey: "enabled")
        userDefaults.synchronize()
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("io.schwa.Deckdick.DeckDickContentBlocker") {
            (error) in
            print("Reloaded: \(error)")
        }
    }
}