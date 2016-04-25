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
    @IBOutlet weak var inputTime: UILabel!
    @IBOutlet weak var outputTime: UILabel!
    
    
    let color = UIColor.greenColor();
    let font = UIFont(name: "Calculator", size: 32.0);
    
    
    var datePicker: UIDatePicker!
    
    // Given date
    let date = NSDate()
    
    
    
    
    
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
    
    
    
    
    
    
    
    
    func datePickerDateChanged(datePicker: UIDatePicker){
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm";
        let formattedTimeStr = formatter.stringFromDate(datePicker.date);

        
        
        print("Selected date = \(formattedTimeStr)")
        
        inputTime.text = "\(formattedTimeStr)"
        outputTime.text = String(format: "%d MetricTime", datePicker.date)
    
    
    }
    
    func segmentedControlValueChanged(sender: UISegmentedControl){
        
        print("segmentedControlValueChanged")
        
            let selectedSegmentIndex = sender.selectedSegmentIndex
        
        
        if selectedSegmentIndex == 0 { //convert to metric
            
         
            
            
        } else if selectedSegmentIndex == 1 { //convert to normal
            
            let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            
            let date10h = calendar.dateBySettingHour(10, minute: 59, second: 0, ofDate: date, options: NSCalendarOptions.MatchFirst)!

            
            datePicker.maximumDate = date10h
            
            
        }
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        inputTime?.font = font
        outputTime?.font = font
        inputTime?.textColor = color
        outputTime?.textColor = color
        
        

        // Do any additional setup after loading the view.
        datePicker = UIDatePicker()
        
        
        datePicker.datePickerMode = .Time
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.tintColor = UIColor.whiteColor()
        datePicker.minuteInterval = 1
        
        // First moment of tody
        let startOfDay = NSCalendar.currentCalendar().startOfDayForDate(date)
        
        datePicker.date = startOfDay
        view.addSubview(datePicker)

        //add constraints 
        // ERROR: these next few lines cause thread 1 signal sigabrt
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: 0.0).active = false
        datePicker.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 15.0).active = true
        datePicker.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 0.0).active = true

        
        
        datePicker.addTarget(self, action: #selector(ConversionViewController.datePickerDateChanged(_:)), forControlEvents: .ValueChanged)
        
        inputTimePicker.addTarget(self, action: #selector(ConversionViewController.segmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        
        
        
        inputTime.text = "00:00"
        outputTime.text = "00:00"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
        
        
        datePicker.removeFromSuperview()
        
        
    }
    

}
