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
    
    var stressTestMode = false;
    var interval = 0.125;

    
    //  the actual time that normal humans use (in millitary time) (actualTime[0] = hour, actualTime[1] = minute, actualTime[2] = second)
    var actualTime: [Int] = [0, 0, 0];
    
    var millisecondsSinceToday = 0;
    //the converted "metric time"
    var metricTime: [Int] = [0, 0, 0];
    
    
    
    
    
    
    
    func updateTime() {
        //get current hour, minute and second
        if !stressTestMode {
            components = NSCalendar.currentCalendar().components([ .Hour, .Minute, .Second], fromDate: NSDate())
            
            actualTime[0] = components.hour;
            actualTime[1] = components.minute;
            actualTime[2] = components.second;
            
        } else {
            
            //increment seconds
            actualTime[2] += 1
            
            //if seconds = 60
             if actualTime[2] == 60 {
                //increment minutes and reset seconds
                
                actualTime[1] += 1
                actualTime[2] = 0
            }
            
            //if min = 60
             if actualTime[1] == 60 {
                //increment hours and reset minutes
                actualTime[0] += 1
                actualTime[1] = 0
            }
            
            //if hours = 24
             if actualTime[0] == 24 {
                //stop timer running.
                timer.invalidate()
                
            }
            
        }
        
        calculateMetricTime()
        
        //display updated values
        
      //  decimalDay?.text = String(format: "%.5f", metricDecimalDay)
        timeDisplay?.text = String(format: "%02d : %02d : %02d", actualTime[0], actualTime[1], actualTime[2])
        metricTimeDisplay?.text = String(format: "%01d : %02d : %02d", metricTime[0], metricTime[1], metricTime[2])
        
        
        if stressTestMode {
            // log values
            print("ActualTime: \(actualTime[0]):\(actualTime[1]):\(actualTime[2])")
            print(" ")
            print("MetricTime: \(metricTime[0]):\(metricTime[1]):\(metricTime[2])")
            print(" ")
            print(" ")
        }


    }
    
    func calculateMetricTime() {
        
            /*calculate metric "hours", "minutes", and "seconds" */
        millisecondsSinceToday = 0
        millisecondsSinceToday = (actualTime[0] * 3600000 /*milliseconds per hour*/) + (actualTime[1] * 60000 /* milliseconds per minute*/) + (actualTime[2] * 1000 /*milliseconds per second*/)
        
        
        //print(Double(millisecondsSinceToday / 8640000))
      
        
        
        metricTime[0] = Int(millisecondsSinceToday / 8640000)//correct

        millisecondsSinceToday -= (metricTime[0]*8640000)
        
        metricTime[1] = Int(millisecondsSinceToday / 86400)//correct
        
        millisecondsSinceToday -= (metricTime[1]*86400)
        
        metricTime[2] = Int(millisecondsSinceToday / 864)
        
    
        
        //Debug
        print("Seconds: \(millisecondsSinceToday / 864)")
        print("Seconds Modulus: \(millisecondsSinceToday % 864)")
        print("ActualTime: \(actualTime[0]):\(actualTime[1]):\(actualTime[2])")
        print("millisecondsSinceToday \(millisecondsSinceToday)") //correct
        print("MetricTime: \(metricTime[0]):\(metricTime[1]):\(metricTime[2])")
        
        print(" ")
        
            }
    
    
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if stressTestMode {
            interval = 0.00001;
        }
        
       
        
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
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        timer.tolerance = 0.04 //allow the timer to be off by a little if iOS needs it...
        
        
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
