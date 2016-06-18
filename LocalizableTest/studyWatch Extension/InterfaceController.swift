//
//  InterfaceController.swift
//  studyWatch Extension
//
//  Created by cz on 16/6/14.
//  Copyright © 2016年 cz. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    
    @IBOutlet var button: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func roundStr() -> String {
        var str = ""
        for _ in 0...3 {
            let s = arc4random()%10
            str += String(s);
        }
        return str
    }
    
    @IBAction func saveDidTap() {
        let value = roundStr()
        
        let  userDefaults = NSUserDefaults(suiteName: "group.com.dajialai.troy")
        userDefaults?.setObject(value, forKey: "shared")
        userDefaults?.synchronize();
    }
    
    @IBAction func didTap() {
        let userDefault = NSUserDefaults(suiteName: "group.com.dajialai.troy")
        userDefault!.synchronize()
        let WXText : String = userDefault?.objectForKey("shared") as! String
        self.label.setText(WXText)
    }
}
