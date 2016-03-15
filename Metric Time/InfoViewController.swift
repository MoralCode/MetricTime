//
//  InfoViewController.swift
//  Metric Time
//
//  Created by ACE on 3/15/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//


import UIKit

class InfoViewController: UIViewController {

    @IBOutlet var infoBox:UITextView?;
    
    
    override func viewDidLoad() {
        
        
        
        infoBox?.text = "About App text here"
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
