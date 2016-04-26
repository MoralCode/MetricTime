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
    
//    @IBOutlet weak var plusHours: UIButton!
//    @IBOutlet weak var minusHours: UIButton!
//    
//    @IBOutlet weak var plusMinutes: UIButton!
//    @IBOutlet weak var minusMinutes: UIButton!
//    
//    @IBOutlet weak var plusSeconds: UIButton!
//    @IBOutlet weak var minusSeconds: UIButton!
    
    let color = UIColor.greenColor();
    let font = UIFont(name: "Calculator", size: 52.0);
    
    var inputTime: [Int] = [0, 0, 0];
    var outputTime: [Int] = [0, 0, 0];

    
    var hoursMax: Int = 24
    var minutesMax: Int = 60
    var secondsMax: Int = 60
    
    
    
    @IBAction func plusHours(sender: UIButton) {
        
        inputTime[0] += 1
        
        if inputTime[0] >= hoursMax {
            inputTime[0] = 0
        }
        
        updateTime()
        
    }

    @IBAction func minusHours(sender: UIButton) {
        
        inputTime[0] -= 1
        
        if inputTime[0] == -1 {
            inputTime[0] = hoursMax
        }
        
        updateTime()
        
    }
    
    
    @IBAction func plusMinutes(sender: UIButton) {
        
        inputTime[1] += 1
        
        if inputTime[1] >= minutesMax {
            inputTime[1] = 0
        }
        
        updateTime()
        
    }
    
    @IBAction func minusMinutes(sender: UIButton) {
        
        inputTime[1] -= 1
        
        if inputTime[1] == -1 {
            inputTime[1] = minutesMax
        }
        
        updateTime()
        
    }
    
    @IBAction func plusSeconds(sender: UIButton) {
        
        inputTime[2] += 1
        
        if inputTime[2] >= secondsMax {
            inputTime[2] = 0
        }
        
        updateTime()
        
    }
    
    @IBAction func minusSeconds(sender: UIButton) {
        
        inputTime[2] -= 1
        
        if inputTime[2] == -1 {
            inputTime[2] = secondsMax
        }
        
        updateTime()
        
    }
    
    
    
    
    
    func updateLabels() {

        
        inputLabel.text = String(format: "%02d:%02d:%02d", inputTime[0], inputTime[1], inputTime[2])
        
        outputLabel.text = String(format: "%02d:%02d:%02d", outputTime[0], outputTime[1], outputTime[2])
        
    }
    
    
    func updateTime() {
        
        if inputTimePicker.selectedSegmentIndex == 0 {
            
            outputTime = convertToMetricTime(inputTime)
            
        } else if inputTimePicker.selectedSegmentIndex == 1 {
            
            convertToNormalTime(inputTime)
        }
        
        updateLabels()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func convertToMetricTime(time:[Int]) -> [Int] {
        
       var millisecondsSinceToday = (time[0] * 3600000 /*milliseconds per hour*/) + (time[1] * 60000 /* milliseconds per minute*/) + (time[2] * 1000 /*milliseconds per second*/)
        
         var convertedTime: [Int] = [0, 0, 0];
        
        convertedTime[0] = Int(millisecondsSinceToday / 8640000)
        millisecondsSinceToday -= (convertedTime[0]*8640000)
        convertedTime[1] = Int(millisecondsSinceToday / 86400)
        millisecondsSinceToday -= (convertedTime[1]*86400)
        convertedTime[2] = Int(millisecondsSinceToday / 864)
        
        
        return convertedTime
    }
    
    
    func convertToNormalTime(time:[Int]) -> [Int] {
        
        var millisecondsSinceToday = (time[0] * 8640000 /*metric milliseconds per hour*/) + (time[1] * 86400 /* metric milliseconds per minute*/) + (time[2] * 864 /*milliseconds per second*/)
        
        var convertedTime: [Int] = [0, 0, 0];
        
        convertedTime[0] = Int(millisecondsSinceToday / 3600000)
        millisecondsSinceToday -= (convertedTime[0]*3600000)
        convertedTime[1] = Int(millisecondsSinceToday / 60000)
        millisecondsSinceToday -= (convertedTime[1]*60000)
        convertedTime[2] = Int(millisecondsSinceToday / 1000)
        
        
        return convertedTime
    }
    
    
    
    
    
    func segmentedControlValueChanged(sender: UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0 { //convert to metric
            
            inputTime = [0, 0, 0]
            
            //accept normal time as input
            hoursMax = 24
            minutesMax = 60
            secondsMax = 60
            
            
        } else if sender.selectedSegmentIndex == 1 { //convert to normal
            
          
            //accept metric time as input
            
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        outputLabel?.font = font
        outputLabel?.textColor = color
        inputLabel?.font = font
        inputLabel?.textColor = color
        
        
        
        
        
        //    metricTimePicker.addTarget(self, action: #selector(ConversionViewController.metricTimePickerDateChanged(_:)), forControlEvents: .ValueChanged)
        
        
        
        outputLabel.text = "00:00:00"
        inputLabel.text = "00:00:00"
        
    }
    
    //Segues always instantiate new view controllers. When going back we want don't want, or need, a new view controller so we will just dismiss the presented one.
    @IBAction func backPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
