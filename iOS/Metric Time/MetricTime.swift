//
//  MetricTime.swift
//  Metric Time
//
//  Created by ACE on 9/29/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//



/* This file contains the core functionality of metrictime, drawing the analog clock, converting times, setting/changing the rotation of the hands .etc
 
 */

import Foundation
import UIKit

class MetricTime {
    //Constants
    let MILLISECONDS_PER_HOUR = 1000*60*60 //3,600,000
    let MILLISECONDS_PER_MINUTE = 1000*60 //60,000
    let MILLISECONDS_PER_SECOND = 1000 //really? do I have to comment the value of this?
    
    let METRIC_MILLISECONDS_PER_HOUR = 864*100*100 //8,640,00
    let METRIC_MILLISECONDS_PER_MINUTE = 864*100 //86,400
    let METRIC_MILLISECONDS_PER_SECOND = 864 //youre kidding me.
    

    
   
    
    /// - returns: The current instance of MetricTime()
    func getInstance() -> MetricTime { return self }
    
    
    /// Gets the current time and converts it to metric
    ///
    /// - returns: The current metric time in (hour: Int, minute: Int, second: Int) format
    func getCurrentMetricTime() -> (hour: Int, minute: Int, second: Int, millisecond: Int) {
    
        
        var currentTime = (Calendar.current as NSCalendar).components([ .hour, .minute, .second, .nanosecond], from: Date())
        var currentMetricTime = (hour: 0, minute: 0, second: 0, millisecond: 0)
    
        //convert each part of the time (h, m, s, ns) into milliseconds
        let hoursInMillis = (currentTime.hour! * MILLISECONDS_PER_HOUR)
        let minsInMillis = (currentTime.minute! * MILLISECONDS_PER_MINUTE)
        let secsInMillis = (currentTime.second! * MILLISECONDS_PER_SECOND)
        let nanosecondsInMillis = (currentTime.nanosecond!/1000000)

        var currentTimeInMilliseconds = hoursInMillis + minsInMillis + secsInMillis + nanosecondsInMillis

        
        //convert current time in milliseconds to metric
        currentMetricTime.hour = currentTimeInMilliseconds / METRIC_MILLISECONDS_PER_HOUR
         
        currentTimeInMilliseconds -= currentMetricTime.hour * METRIC_MILLISECONDS_PER_HOUR
         
        currentMetricTime.minute = currentTimeInMilliseconds / METRIC_MILLISECONDS_PER_MINUTE
        
        currentTimeInMilliseconds -= currentMetricTime.minute * METRIC_MILLISECONDS_PER_MINUTE
         
        currentMetricTime.second = currentTimeInMilliseconds / METRIC_MILLISECONDS_PER_SECOND
        
        currentTimeInMilliseconds -= currentMetricTime.second * METRIC_MILLISECONDS_PER_SECOND
        
        currentMetricTime.millisecond = currentTimeInMilliseconds

        return currentMetricTime
         
 
 
    }
    
    
    /// Converts between metric and standard time
    ///
    /// - parameter inputTime: The time to convert from in (hour: Int, minute: Int, second: Int) format
    /// - parameter toMetric: A boolean value that determines if thr functions should convert to metric or from metric. Defaults to true (AKA convert to metric)
    /// - returns: The converted time in (hour: Int, minute: Int, second: Int, millisecond: Int) format
    func convertTime(inputTime: (hour: Int, minute: Int, second: Int, millisecond: Int), toMetric:Bool = true) -> (hour: Int, minute: Int, second: Int, millisecond: Int) {
        
        var inputTimeMillis = 0
        var convertedTime = (hour: 0, minute: 0, second: 0, millisecond: 0)
        
        
        if toMetric {
            //if converting to metric, then the input time is assumed to be in standard time system
            //convert to milliseconds
            inputTimeMillis = (inputTime.hour * MILLISECONDS_PER_HOUR) + (inputTime.minute * MILLISECONDS_PER_MINUTE) + (inputTime.second * MILLISECONDS_PER_SECOND)
        } else {
            inputTimeMillis = (inputTime.hour * METRIC_MILLISECONDS_PER_HOUR) + (inputTime.minute * METRIC_MILLISECONDS_PER_MINUTE) + (inputTime.second * METRIC_MILLISECONDS_PER_SECOND)
        }
        
        convertedTime.hour = Int(inputTimeMillis) / METRIC_MILLISECONDS_PER_HOUR
        inputTimeMillis = Int(inputTimeMillis) % METRIC_MILLISECONDS_PER_HOUR
        
        convertedTime.minute = Int(inputTimeMillis) / METRIC_MILLISECONDS_PER_MINUTE
        inputTimeMillis = Int(inputTimeMillis) % METRIC_MILLISECONDS_PER_MINUTE
        
        convertedTime.second = Int(inputTimeMillis) / METRIC_MILLISECONDS_PER_SECOND
        convertedTime.millisecond = Int(inputTimeMillis) % METRIC_MILLISECONDS_PER_SECOND
        
        return convertedTime
    }
    
    func convertTime(inputTime: (hour: Int, minute: Int, second: Int), toMetric:Bool = true) -> (hour: Int, minute: Int, second: Int) {
        let result = convertTime(inputTime: (hour: inputTime.hour, minute: inputTime.minute, second: inputTime.second, millisecond: 0), toMetric: toMetric)
        //is there a way to drop the milliseconds from the output without creating a variable?
        return (hour: result.hour, minute: result.minute, second: result.second)
        
    }
    
}
