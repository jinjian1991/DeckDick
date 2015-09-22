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
//        let plugins = NSBundle.mainBundle().bundleURL
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("io.schwa.Deckdick.DeckDickContentBlocker") {
            (error) in
            print("Reloaded: \(error)")
        }
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

