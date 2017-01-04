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
    @IBOutlet weak var IMTSFlag: UILabel!

    
    let color = UIColor.green;
    let font = UIFont(name: "Calculator", size: 70.0);
    

    var inputTime: (hour: Int, minute: Int, second: Int) = (0,0,0)
    var outputTime: (hour: Int, minute: Int, second: Int) = (0,0,0)
    
    var hoursMax: Int = 24
    var minutesMax: Int = 60
    var secondsMax: Int = 60
    
    
    
    @IBAction func plusHours(_ sender: UIButton) {
        inputTime.hour += 1
        if inputTime.hour >= hoursMax {inputTime.hour = 0}
        updateTime()
    }

    @IBAction func minusHours(_ sender: UIButton) {
        inputTime.hour -= 1
        if inputTime.hour == -1 {inputTime.hour = hoursMax-1}
        updateTime()
    }
    
    @IBAction func plusMinutes(_ sender: UIButton) {
        inputTime.minute += 1
        if inputTime.minute >= minutesMax {inputTime.minute = 0}
        updateTime()
    }
    
    @IBAction func minusMinutes(_ sender: UIButton) {
        inputTime.minute -= 1
        if inputTime.minute == -1 {inputTime.minute = minutesMax-1}
        updateTime()
    }
    
    @IBAction func plusSeconds(_ sender: UIButton) {
        inputTime.second += 1
        if inputTime.second >= secondsMax {inputTime.second = 0}
        updateTime()
    }
    
    @IBAction func minusSeconds(_ sender: UIButton) {
        inputTime.second -= 1
        if inputTime.second == -1 {inputTime.second = secondsMax-1}
        updateTime()
    }
    
    
    
    
    
    func updateLabels() {

        
        inputLabel.text = String(format: "%02d:%02d:%02d", inputTime.hour, inputTime.minute, inputTime.second)
        
        outputLabel.text = String(format: "%02d:%02d:%02d", outputTime.hour, outputTime.minute, outputTime.second)
        
    }
    
    
    func updateTime() {
        
        if inputTimePicker.selectedSegmentIndex == 0 {
            
            outputTime = MetricTime().convertTime(inputTime: inputTime, toMetric: true)
            
        } else if inputTimePicker.selectedSegmentIndex == 1 {
            
            outputTime = MetricTime().convertTime(inputTime: inputTime, toMetric: false)
        }
        
        updateLabels()
    }
    
    
    
    func segmentedControlValueChanged(_ sender: UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0 { //convert to metric
            
            //clear values from input/output labels
            inputTime = (0, 0, 0)
            updateTime()
            
            //accept normal time as input
            hoursMax = 24
            minutesMax = 60
            secondsMax = 60
            
            IMTSFlag.isHidden = false
            
            
        } else if sender.selectedSegmentIndex == 1 { //convert to normal
            
          
            //clear values from input/output labels
            inputTime = (0, 0, 0)
            updateTime()
            
            //accept metric time as input
            hoursMax = 10
            minutesMax = 100
            secondsMax = 100
            
            IMTSFlag.isHidden = true

            
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        outputLabel?.font = font
        outputLabel?.textColor = color
        inputLabel?.font = font
        inputLabel?.textColor = color
        
        
        inputTimePicker.addTarget(self, action: #selector(ConversionViewController.segmentedControlValueChanged(_:)), for: .valueChanged)

        
        
        outputLabel.text = "00:00:00"
        inputLabel.text = "00:00:00"
        
    }
    
    //Segues always instantiate new view controllers. When going back we want don't want, or need, a new view controller so we will just dismiss the presented one.
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
