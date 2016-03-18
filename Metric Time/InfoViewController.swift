//
//  InfoViewController.swift
//  Metric Time
//
//  Created by ACE on 3/15/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//


import UIKit

class InfoViewController: UIViewController {

    @IBOutlet var infoBox:UITextView?
    @IBOutlet var useSplitDay:UISwitch?
    @IBOutlet var hideOnNextLaunch:UISwitch?
    
    
    override func viewDidLoad() {
        
        
        
        infoBox?.text = "About app text here"
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        NSUserDefaults.standardUserDefaults().setBool((useSplitDay?.on)!, forKey: "useSplitDay")
        NSUserDefaults.standardUserDefaults().setBool((hideOnNextLaunch?.on)!, forKey: "hideOnNextLaunch")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
