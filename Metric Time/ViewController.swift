//
//  ViewController.swift
//  Metric Time
//
//  Created by ACE on 2/15/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var timeDisplay:UILabel?
    @IBOutlet var decimalDay:UILabel?
    @IBOutlet var metricTimeDisplay:UILabel?
    @IBOutlet var infoScreenButton:UIButton?
    
    
    var components = NSCalendar.currentCalendar().components( [.Hour, .Minute, .Second], fromDate: NSDate())
    var timer = NSTimer();
    
    
    let color = UIColor.greenColor();
    let font = UIFont(name: "Calculator", size: 52.0);
    
    
    
    var deciday = 0; //(2h 24m)
    var centiday = 0;//(14m 24s)
    var milliday = 0;//(1m 26.4s)
    var microday = 0;//(86.4 ms)
    
    
    
    var metricDecimalDay:Float = 0 //shows how far you are through the day as a decimal (noon is .500000)
    
    //  the actual time that normal humans use (in millitary time)
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    //these help calculate metricDecimalDay 
    var splitDayHours:Double = 0
    var splitDayMinutes:Double = 0
    var splitDaySeconds:Double = 0
    
    
    func updateTime() {
        //get current hour, minute and second
        components = NSCalendar.currentCalendar().components([ .Hour, .Minute, .Second], fromDate: NSDate())
        hours = components.hour;
        minutes = components.minute;
        seconds = components.second;
        
        calculateMetricTime()
        
        //display updated values
        
         decimalDay?.text = String(format: "%.5f", metricDecimalDay)
        timeDisplay?.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("useSplitDay") == true {
            metricTimeDisplay?.text = String(format: "%01d : %02d : %02d", splitDayHours, splitDayMinutes, splitDaySeconds)
        }
        
    }
    
    func calculateMetricTime() {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("useSplitDay") == true {
            //parts of day time here.
            
            
            splitDayHours = Double(hours)/24
            splitDayMinutes = Double(minutes)/1440
            splitDaySeconds = Double(seconds)/86400
            
            metricDecimalDay = Float(splitDayHours) + Float(splitDayMinutes) + Float(splitDaySeconds)
            
            //calculate metric "hours", "minutes", and "seconds"
            //deciday = (int)(day * 10); milliday = (int)(day * 1000) % 100; msec = (int)(day * 100000) % 100;
            splitDayHours = Int(metricDecimalDay * 10)
            splitDayMinutes = Int(metricDecimalDay * 1000) % 100
            splitDaySeconds = Int(metricDecimalDay * 100000) % 100
            
            print(splitDayHours)
            print(splitDayMinutes)
            print(splitDaySeconds)
            print(" ")
            
        } else {
            
            //100->100 timekeeping here
            
            
        }
    }
    
    
    
    
    override func viewDidLoad() {
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hideOnNextLaunch") == true {
            
            infoScreenButton?.hidden = true
            
        }
        
        
        
        
        super.viewDidLoad()
        
        //load the font and color the text boxes
        timeDisplay?.font = font
        decimalDay?.font = font
        metricTimeDisplay?.font = font
        timeDisplay?.textColor = color
        decimalDay?.textColor = color
        metricTimeDisplay?.textColor = color
        
        
        updateTime()
        
        
       // if NSUserDefaults.standardUserDefaults().boolForKey("useSplitDay") == true { let interval = 0.1; ) else { let interval =  }

        
        //set timer
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        timer.tolerance = 0.4 //allow the timer to be off by up to 0.4 seconds if iOS needs it...
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        timer.invalidate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

