//
//  MainViewController.swift
//  Metric Time
//
//  Created by ACE on 10/3/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//



/*
This file controls the main metricTime screen and its behavior, such as:
 - gestures
 - positioning views
 - run loops
 - changing on-screen text
 
 
 */

import UIKit


class MainViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet var metricTimeDisplay:UILabel?

    
    fileprivate var displayLink:CADisplayLink?
    
    var gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    var components = (Calendar.current as NSCalendar).components( [.hour, .minute, .second], from: Date())
    
    let metricTime:MetricTime = MetricTime()
   
    
    
 
    func updateTime() {
        
        components = (Calendar.current as NSCalendar).components([ .hour, .minute, .second, .nanosecond], from: Date())
        
        let currentMetricTime = metricTime.getCurrentMetricTime(currentTime: components)
        
        
        //update clock
        metricTime.updateHandsPosition(metricTime: (hour: currentMetricTime.hour, minute: currentMetricTime.minute, second: currentMetricTime.second))

  //      rotateHands(clockView, rotation: (positions.h, positions.m, positions.s) )
        
        metricTimeDisplay?.text = String(format: "%01d : %02d : %02d", currentMetricTime.hour, currentMetricTime.minute, currentMetricTime.second)
    }
 
 
    func handleGesture(sender: UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began {
            //remove the gesture recogniser so it doesnt get called while the Convertion view is segue-ing in...
            view.removeGestureRecognizer(gesture)
            
            let conversionView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "conversionView")
            
            // and then present it modally
            show(conversionView, sender: nil)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let clock:UIView = metricTime.drawAnalogClock()
       
        //is this needed?
        view.isUserInteractionEnabled = true
        
        //position clock view
        self.view.addSubview(clock)
        clock.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            clock.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = false
            
            clock.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15.0).isActive = true
            clock.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
            clock.widthAnchor.constraint(equalToConstant: 230.0).isActive = true
            clock.heightAnchor.constraint(equalToConstant: 230.0).isActive = true
        } else {
            //TODO: Fallback on earlier versions
        }

        
        //It is better to use an CADisplayLink for timing related to animation. This is why you have an issue with dropping ticks/frames.
        //NSTimer executes when it's convenient for the run loop could be before or after the display has been rendered. CADisplayLink will always be executed prior to pixels being pushed to the screen. For more on this watch the video here: https://developer.apple.com/videos/play/wwdc2014/236/
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateTime))
        self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //re-add the gesture recognizer so the convertion screen can be re-accessed...
        view.addGestureRecognizer(gesture)
        
    }
    

}
