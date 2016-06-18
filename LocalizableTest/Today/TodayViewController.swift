//
//  TodayViewController.swift
//  Today
//
//  Created by cz on 16/6/14.
//  Copyright © 2016年 cz. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.preferredContentSize = CGSizeMake(0, 100)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userDefault = NSUserDefaults(suiteName: "group.com.dajialai.troy")
        userDefault!.synchronize()
        let WXText = userDefault?.objectForKey("shared") as? String
        self.label.text = WXText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func buttonDidTap(sender: UIButton) {
        let url = NSURL(string: "troy://authentication")
        
        self.extensionContext?.openURL(url!, completionHandler: { (success) in
            print("success!")
        })
    }
    
    
}
