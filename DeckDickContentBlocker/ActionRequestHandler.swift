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

    func beginRequestWithExtensionContext(context: NSExtensionContext) {

        let userDefaults = NSUserDefaults(suiteName: "group.io.schwa.DeckDick")!
        let enabled = userDefaults.boolForKey("enabled")
        NSLog("DeckDick Extension enabled? \(enabled)")

        let name = enabled ? "BlockerList" : "Disabled"

        let url = NSBundle.mainBundle().URLForResource(name, withExtension: "json")!
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
}
