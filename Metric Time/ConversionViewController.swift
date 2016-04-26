//
//  ConversionViewController.swift
//  Metric Time
//
//  Created by ACE on 4/24/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    
    @IBOutlet weak var inputTimePicker: UISegmentedControl!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var plusHoursButton: UIButton!
    @IBOutlet weak var minusHoursButton: UIButton!
    
    @IBOutlet weak var plusMinutesButton: UIButton!
    @IBOutlet weak var minusMinutesButton: UIButton!
    
    @IBOutlet weak var plusSecondsButton: UIButton!
    @IBOutlet weak var minusSecondsButton: UIButton!
    
    let color = UIColor.greenColor();
    let font = UIFont(name: "Calculator", size: 52.0);
    

    
    
    
    
    
    var actualTime:[Int] = [0, 0, 0] //change this variable to the hours, minutes and seconds of the time you want to convert (millitary time please) (e.x. [13, 55, 42] for 1:55:42)
    
    
    var metricTime:[Int] = [0, 0, 0]
    var millisecondsSinceToday = 0
    
    
    
    
    
    
    
    func convertToMetricTime(time:[Int]) -> [Int] {
        
        millisecondsSinceToday = (actualTime[0] * 3600000 /*milliseconds per hour*/) + (actualTime[1] * 60000 /* milliseconds per minute*/) + (actualTime[2] * 1000 /*milliseconds per second*/)
        
        
        metricTime[0] = Int(millisecondsSinceToday / 8640000)
        millisecondsSinceToday -= (metricTime[0]*8640000)
        metricTime[1] = Int(millisecondsSinceToday / 86400)
        millisecondsSinceToday -= (metricTime[1]*86400)
        metricTime[2] = Int(millisecondsSinceToday / 864)
        
        
        return metricTime
    }
    
    
    
    
    
    
    
    
    
//        let formatter = NSDateFormatter();
//        formatter.dateFormat = "HH:mm";
//        let formattedTimeStr = formatter.stringFromDate(normalTimePicker.date);
//        
//        
//        
//        print("Selected date = \(formattedTimeStr)")
//        
//        
//        outputLabel.text = String(format: "%d MetricTime", normalTimePicker.date)
//        
    
 
    
    
    
    
    func segmentedControlValueChanged(sender: UISegmentedControl){
        
        print("segmentedControlValueChanged")
        
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        
        if selectedSegmentIndex == 0 { //convert to metric
            
            
            
            
        } else if selectedSegmentIndex == 1 { //convert to normal
            
          
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        outputLabel?.font = font
        outputLabel?.textColor = color
        inputLabel?.font = font
        inputLabel?.textColor = color
        
        
        
        
        
        //    metricTimePicker.addTarget(self, action: #selector(ConversionViewController.metricTimePickerDateChanged(_:)), forControlEvents: .ValueChanged)
        
        
        
        outputLabel.text = "00:00"
        inputLabel.text = "00:00"
        
    }
    
    //Segues always instantiate new view controllers. When going back we want don't want, or need, a new view controller so we will just dismiss the presented one.
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
