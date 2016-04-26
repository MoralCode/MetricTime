//
//  ConversionViewController.swift
//  Metric Time
//
//  Created by ACE on 4/24/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var inputTimePicker: UISegmentedControl!
    @IBOutlet weak var inputTime: UILabel!
    @IBOutlet weak var outputTime: UILabel!
    
    
    let color = UIColor.greenColor();
    let font = UIFont(name: "Calculator", size: 32.0);
    
    
    var normalTimePicker: UIDatePicker!
    var metricTimePicker: UIPickerView!
    
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
    
    
    
    
    
    
    
    
    func normalTimePickerDateChanged(normalTimePicker: UIDatePicker){
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm";
        let formattedTimeStr = formatter.stringFromDate(normalTimePicker.date);
        
        
        
        print("Selected date = \(formattedTimeStr)")
        
        inputTime.text = "\(formattedTimeStr)"
        outputTime.text = String(format: "%d MetricTime", normalTimePicker.date)
        
        
    }
    
    
    
    func metricTimePickerDateChanged(normalTimePicker: UIDatePicker){
        
        
    }
    
    
    func segmentedControlValueChanged(sender: UISegmentedControl){
        
        print("segmentedControlValueChanged")
        
        let selectedSegmentIndex = sender.selectedSegmentIndex
        
        
        if selectedSegmentIndex == 0 { //convert to metric
            
            metricTimePicker.hidden = true
            normalTimePicker.hidden = false
            
            
        } else if selectedSegmentIndex == 1 { //convert to normal
            
            metricTimePicker.hidden = false
            normalTimePicker.hidden = true
            
        }
        
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == metricTimePicker{
            return 2
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == metricTimePicker{
            
            if component == 0 {
                return 10
            } else if component == 1 {
                
                return 100
            }
            
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return "\(row + 1)"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        inputTime?.font = font
        outputTime?.font = font
        inputTime?.textColor = color
        outputTime?.textColor = color
        
        inputTimePicker.addTarget(self, action: #selector(ConversionViewController.segmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        
        
        // Do any additional setup after loading the view.
        normalTimePicker = UIDatePicker()
        
        
        normalTimePicker.datePickerMode = .Time
        normalTimePicker.backgroundColor = UIColor.whiteColor()
        normalTimePicker.tintColor = UIColor.whiteColor()
        normalTimePicker.minuteInterval = 1
        
        // First moment of tody
        let startOfDay = NSCalendar.currentCalendar().startOfDayForDate(date)
        
        normalTimePicker.date = startOfDay
        view.addSubview(normalTimePicker)
        
        //add constraints
        normalTimePicker.translatesAutoresizingMaskIntoConstraints = false
        normalTimePicker.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: 0.0).active = false
        normalTimePicker.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 15.0).active = true
        normalTimePicker.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 0.0).active = true
        
        
        
        normalTimePicker.addTarget(self, action: #selector(ConversionViewController.normalTimePickerDateChanged(_:)), forControlEvents: .ValueChanged)
        
        
        
        metricTimePicker = UIPickerView()
        
        metricTimePicker.backgroundColor = UIColor.whiteColor()
        metricTimePicker.tintColor = UIColor.whiteColor()
        metricTimePicker.dataSource = self
        metricTimePicker.delegate = self
        
        
        view.addSubview(metricTimePicker)
        //add constraints
        metricTimePicker.translatesAutoresizingMaskIntoConstraints = false
        metricTimePicker.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: 0.0).active = false
        metricTimePicker.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 15.0).active = true
        metricTimePicker.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 0.0).active = true
        
        metricTimePicker.hidden = true
        
        
        
        
        //    metricTimePicker.addTarget(self, action: #selector(ConversionViewController.metricTimePickerDateChanged(_:)), forControlEvents: .ValueChanged)
        
        
        
        
        inputTime.text = "00:00"
        outputTime.text = "00:00"
        
    }
    
    //Segues always instantiate new view controllers. When going back we want don't want, or need, a new view controller so we will just dismiss the presented one.
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
