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
    
    //SETTINGS
    let clockShouldTick = false //setting. not fully implemented

    
    //ANALOG CLOCK
    let clockContext:CGContext? = UIGraphicsGetCurrentContext()
    var clockView = Clock(frame: CGRect(x: 0, y: 0, width: 230, height: 230))

    
    let clockViewRadius = 0;//unused
    let clockColor:CGColor = UIColor.green.cgColor
    let numbersFont = UIFont(name: "DamascusBold", size: 23.0)//manually calculated size from radius/2
    let numberInset:CGFloat = 3.2
    
    
    //CONVERTING TIME

    var lastCall:Date?
    
  

    
    
    
    
    
    
    
    
    /// - returns: The CGContext that is being used by the current instance of MetricTime()
    func getContext() -> CGContext { return self.clockContext!}
    
    /// - returns: The current instance of MetricTime()
    func getInstance() -> MetricTime { return self }
    
    /// - returns: The clockView object from the current instance of MetricTime()
    func getAnalogClock() -> UIView { return clockView }
    
    /*
    THESE FUNCTIONS ARE CALLED WHENEVER A NEW Clock() VIEW IS CREATED
     */
    
    /// Draws and displays the Arc that makes up the curcumference of the clock face
    func drawClockCircle() {
        
        //draw the circle
        clockContext?.addArc(center: CGPoint(x: clockView.bounds.midX, y: clockView.bounds.midY), radius: clockView.bounds.width/2, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        clockContext?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        if clockContext != nil {
            clockContext!.setStrokeColor(UIColor.white.cgColor)
            clockContext!.setLineWidth(4.0)
        }
    }
    /// Calculates the x and y values for the specified number of points around the circle
    ///
    /// - parameter forNumbers: Boolean value that is used when calculating the points at which to render the numbers
    /// - returns: An array of CGPoint's
    private func getPointsOnCircle(forNumbers:Bool = false) -> [CGPoint] {
        
        var desiredNumberOfPoints = 100
        var inset:CGFloat = 0
        var adjustment:CGFloat = 0 //this allows you to change the (rotation) position of the output points to adjust the text rendering

    
        if forNumbers {
            desiredNumberOfPoints = 10
            inset = (clockView.bounds.width/2)/numberInset
            adjustment = -90 //same as 270
        }
        
        var counter = desiredNumberOfPoints //this must stay as is. dont remove the counter variable
        let tickSpacing = degree2radian(360/CGFloat(desiredNumberOfPoints))
        let desiredPointRadius = (clockView.bounds.width/2)-inset //the difference between this and the actual radius of the clock is the inset value
        
        var points = [CGPoint]()
        
        while points.count <= desiredNumberOfPoints {
            //complex maths... modify at own risk...
            let x = clockView.bounds.midX - desiredPointRadius * cos(tickSpacing * CGFloat(counter)+degree2radian(adjustment))
            let y = clockView.bounds.midY - desiredPointRadius * sin(tickSpacing * CGFloat(counter)+degree2radian(adjustment))
            points.append(CGPoint(x: x, y: y))
            counter -= 1;
            print(counter)
        }
        print("cut")
        return points
        
    }

    func addTickMarks() {
        let points = getPointsOnCircle()
        let tickPath = CGMutablePath()
        var tickLength: CGFloat
        
        for point in points.enumerated() {
            
            if point.offset % 10 == 0 {//if the "index" of the point is divisible by 10 w/o remainder
                tickLength = 2/16
            } else if point.offset % 5 == 0 {//if the "index" of the point is divisible by 5 w/o remainder
                tickLength = 3/16
            } else {
                tickLength = 1/16
            }
            
            let tickEndPoint = (x: point.element.x + tickLength*(clockView.bounds.midX - point.element.x), y: point.element.y + tickLength*(clockView.bounds.midY - point.element.y))
            
            clockContext?.move(to: CGPoint(x: point.element.x, y: point.element.y))
            clockContext?.addLine(to: CGPoint(x: tickEndPoint.x, y: tickEndPoint.y))
            clockContext?.addPath(tickPath)
            
        }
        
        clockContext?.setStrokeColor(clockColor)
        clockContext?.setLineWidth(3.0)
        clockContext?.strokePath()
        
    }
    
    //INCOMPLETE!
    func addNumbers() {
        
        
        let numberPositions = getPointsOnCircle(forNumbers: true) //inset determines spacing between numbers and edge of the clock
        
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        clockContext?.translateBy(x: 0.0, y: clockView.bounds.height)
        clockContext?.scaleBy(x: 1.0, y: -1.0)
        
        let textAttributes = [NSFontAttributeName:numbersFont!, NSForegroundColorAttributeName:clockColor] as CFDictionary
        
        // multiplier enables correcting numbering when fewer than 12 numbers are featured, e.g. 4 sides will display 12, 3, 6, 9 (formerly preceeded by a 270 degree adjustment... qué?)
        let multiplier = 12/10
        
        
        for point in numberPositions.enumerated() {
            
            // create the attributed string
             let str = String(point.offset * multiplier)
             let text = CFAttributedStringCreate(nil, str as CFString!, textAttributes)
            
            
             // create the line of text
             let line = CTLineCreateWithAttributedString(text!)
            
            
             // retrieve the bounds of the text
             let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
            
             // set the line width to stroke the text with
             clockContext?.setLineWidth(1.5)
            
             // set the drawing mode to stroke
             clockContext?.setTextDrawingMode(CGTextDrawingMode.stroke)
            
             // Set text position and draw the line into the graphics context, text length and height is adjusted for
             let xn = point.element.x - bounds.width/2
             let yn = point.element.y - bounds.midY
            
             clockContext?.textPosition = CGPoint(x: xn, y: yn)
            
             // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
             // draw the line of text
             CTLineDraw(line, clockContext!)
            
            
        }
        
        
    }
    
    
    
    
    func addClockHands() {
        
        
        
        
        let hourPath = CGMutablePath()
        let minutePath = CGMutablePath()
        let secondPath = CGMutablePath()
        
        //all hand shapes start in center
        hourPath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        minutePath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        secondPath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        
        //draw line straight up at specified lengths
        hourPath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-50))
        minutePath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-62.5))
        secondPath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-75))
        
        //layers are then rotated from these vertical positions
        
        
        let hourLayer = CAShapeLayer()
        let minuteLayer = CAShapeLayer()
        let secondLayer = CAShapeLayer()
        let centerPiece = CAShapeLayer()
        
        //set the views to the same size [views are a little big tho...]?
        hourLayer.frame = clockView.frame
        minuteLayer.frame = clockView.frame
        secondLayer.frame = clockView.frame
        
        hourLayer.path = hourPath
        minuteLayer.path = minutePath
        secondLayer.path = secondPath
        
        //set line thicknesses
        hourLayer.lineWidth = 4
        minuteLayer.lineWidth = 3
        secondLayer.lineWidth = 1
        
        //set line ending
        hourLayer.lineCap = kCALineCapRound
        minuteLayer.lineCap = kCALineCapRound
        secondLayer.lineCap = kCALineCapRound
    
        
        //set color
        hourLayer.strokeColor = UIColor.white.cgColor
        minuteLayer.strokeColor = UIColor.white.cgColor
        secondLayer.strokeColor = UIColor.red.cgColor
        
        
        hourLayer.rasterizationScale = UIScreen.main.scale;
        minuteLayer.rasterizationScale = UIScreen.main.scale;
        secondLayer.rasterizationScale = UIScreen.main.scale;
        
        hourLayer.shouldRasterize = true
        minuteLayer.shouldRasterize = true
        secondLayer.shouldRasterize = true
        
    
        //finally add the center piece
        
       // let circle = UIBezierPath(arcCenter: CGPoint(x:clockView.frame.midX,y:clockView.frame.midX), radius: 2.75, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        centerPiece.path = UIBezierPath(arcCenter: CGPoint(x:clockView.frame.midX,y:clockView.frame.midX), radius: 2.75, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true).cgPath
        centerPiece.fillColor = UIColor.gray.cgColor
        
        
        //add all the layers to clockView as subviews
        clockView.layer.addSublayer(hourLayer)
        clockView.layer.addSublayer(minuteLayer)
        clockView.layer.addSublayer(secondLayer)
        clockView.layer.addSublayer(centerPiece)
        
        
    }
    

    
    
    //INCOMPLETE!

    func updateHandsPosition(metricTime: (hour: Int, minute: Int, second: Int)) {
        
        setHandsAngle(handDegrees: getHandsPosition(metricTime: (hour: metricTime.hour, minute: metricTime.minute, second: metricTime.second)))
    }
    //WHAT?
    func getHandsPosition(metricTime: (hour: Int, minute: Int, second: Int)) -> (hAngle:CGFloat, mAngle:CGFloat, sAngle:CGFloat) {
        
        var secondsAngle = (Double(metricTime.second)/100)
        var minutesAngle = (Double(metricTime.minute)/100 + Double(metricTime.second)/10000.0)
        var hoursAngle = (Double(metricTime.hour)/10) + minutesAngle/10 //this line must come after minutesAngle Calculation... (feels hacky to me)
        
        hoursAngle = hoursAngle*360
        minutesAngle = minutesAngle*360
        secondsAngle = secondsAngle*360
        
        
        return (hAngle: degree2radian(CGFloat(hoursAngle)),mAngle: degree2radian(CGFloat(minutesAngle)),sAngle: degree2radian(CGFloat(secondsAngle)))
    }

    func setHandsAngle(handDegrees: (hAngle:CGFloat, mAngle:CGFloat, sAngle:CGFloat)) {
        
         hourLayer.transform = CATransform3DMakeRotation(handDegrees.hAngle, 0, 0, 1)
         minuteLayer.transform = CATransform3DMakeRotation(handDegrees.mAngle, 0, 0, 1)
         secondLayer.transform = CATransform3DMakeRotation(handDegrees.sAngle, 0, 0, 1)
        
        
    }

    func getCurrentMetricTime(currentTime:DateComponents) -> (hour: Int, minute: Int, second: Int) {
        
//        //why wont this work with smoothing out the clock...
//        if !clockShouldTick {
//            
//            seconds = Double(currentTime.second!) + Double(currentTime.nanosecond!)/1000000000.0
//            
//            
//            if let lastTimeCalled = lastCall //unwrap
//            {
//                //actualTime[2] += Int(0.0 * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0)
//                seconds += 0.0 * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0
//            }
//            
//            lastCall = Date()
//            
//        } else { seconds = Double(currentTime.second!) }
//
//        
        
        //remind me what the f these do again?
         var seconds = 0.0
        var convertedSeconds = 0.0

        
        //convert current time to milliseconds
        var millisecondsSinceToday = Double(currentTime.hour! * 3600000 /*milliseconds per hour*/) + Double(currentTime.minute! * 60000 /* milliseconds per minute*/) + Double(seconds * 1000.0 /*milliseconds per second*/)

        
        var currentMetricTime = (hour: 0, minute: 0, second: 0)
        
        
        //convert current time in milliseconds to metric
        currentMetricTime.hour = Int(millisecondsSinceToday / 8640000)
         
        millisecondsSinceToday -= Double(currentMetricTime.hour*8640000)
         
        currentMetricTime.minute = Int(millisecondsSinceToday / 86400)
        
        millisecondsSinceToday -= Double(currentMetricTime.minute*86400)
         
        currentMetricTime.second = Int(millisecondsSinceToday / 864)
        convertedSeconds = Double(millisecondsSinceToday / 864) //?
        
        
        return currentMetricTime
         
 
 
    }
    
    func convertTime(inputTime: (hour: Int, minute: Int, second: Int), toMetric:Bool = true) -> (hour: Int, minute: Int, second: Int) {
        
        var inputTimeMillis = 0
        var convertedTime = (hour: 0, minute: 0, second: 0)
        
        
        if toMetric {
            inputTimeMillis = (inputTime.hour * 3600000 /*milliseconds per hour*/) + (inputTime.minute * 60000 /* milliseconds per minute*/) + (inputTime.second * 1000 /*milliseconds per second*/)
        } else {
            inputTimeMillis = (inputTime.hour * 8640000 /*metric milliseconds per hour*/) + (inputTime.minute * 86400 /* metric milliseconds per minute*/) + (inputTime.second * 864 /*milliseconds per second*/)
        }
        
        
        convertedTime.hour = Int(inputTimeMillis / 8640000)
        inputTimeMillis -= (convertedTime.hour*8640000)
        
        convertedTime.minute = Int(inputTimeMillis / 86400)
        inputTimeMillis -= (convertedTime.minute*86400)
        
        convertedTime.second = Int(inputTimeMillis / 864)
        //screw milliseconds, convertions dont need to be THAT accurate do they?
        
        return convertedTime
    }
    
    
    
    

    
    

    
    
}


class Clock: UIView {
    
    override func draw(_ rect: CGRect) {
        
        //do things as soon as a new Clock object is created?????
        //probably dont need?
        let metricTime:MetricTime = MetricTime()//may cause some issues?
        
        
     //   let context = metricTime.getContext()
       // let context = UIGraphicsGetCurrentContext()
        
       // context.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: CGFloat(metricTime.clockRadius), startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
       // context.drawPath(using: CGPathDrawingMode.fillStroke);
        metricTime.drawClockCircle()
        metricTime.addTickMarks()
        metricTime.addNumbers()
        metricTime.addClockHands()
        
        
        
    }
    
}
