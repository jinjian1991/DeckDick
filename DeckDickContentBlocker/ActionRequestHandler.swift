//
//  ActionRequestHandler.swift
//  DeckDickContentBlocker
//
//  Created by Jonathan Wight on 9/22/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    let testLoad = true
    var userDefaults: NSUserDefaults
    var enabled: Bool
    var url: NSURL

    override init() {
        userDefaults = NSUserDefaults(suiteName: "group.io.schwa.DeckDick")!
        enabled = userDefaults.boolForKey("enabled")
        if enabled == false {
            url = NSBundle.mainBundle().URLForResource("Disabled", withExtension: "json")!
        }
        else {
            let groupDirectoryURL = NSFileManager().containerURLForSecurityApplicationGroupIdentifier("group.io.schwa.DeckDick")
            let possibleURL = groupDirectoryURL!.URLByAppendingPathComponent("BlockerList.json")
            if possibleURL.checkPromisedItemIsReachableAndReturnError(nil) {
                url = possibleURL
            }
            else {
                url = NSBundle.mainBundle().URLForResource("BlockerList", withExtension: "json")!
            }
        }

        super.init()

        log("Using \(url)")
    }

    func beginRequestWithExtensionContext(context: NSExtensionContext) {

        log("Extension enabled? \(enabled)")

        if testLoad == true {
            let data = NSData(contentsOfURL: url)!
            try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            NSLog("DeckDick Extension JSON loaded")
        }
        let attachment = NSItemProvider(contentsOfURL: url)!
        let item = NSExtensionItem()
        item.attachments = [attachment]
        context.completeRequestReturningItems([item], completionHandler: nil);
    }

    func log(any:Any) {
        NSLog("[DeckDick]: \(any)")
    }
}
