//
//  MetricTime.swift
//  Metric Time
//
//  Created by ACE on 9/29/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//



/* This file contains the core functionality of metrictime, drawing the analog clock, converting times, moving the hands(?) .etc
 
 
 */

import Foundation
import UIKit

class MetricTime {
    
    let hourLayer = CAShapeLayer()
    let minuteLayer = CAShapeLayer()
    let secondLayer = CAShapeLayer()
    let centerPiece = CAShapeLayer()
    
    var lastCall:Date?
    let clockShouldTick = false
    
    //  the actual time that normal humans use (in millitary time) (actualTime[0] = hour, actualTime[1] = minute, actualTime[2] = second)
    var actualTime: [Int] = [0, 0, 0];
    
    
    //the converted "metric time"
    var metricTime = (hour: 0, minute: 0, second: 0) //used in getCurrentMetricTime and smth else...
    var seconds = 0.0
    var convertedSeconds = 0.0

    var clockView = Clock()
    let clockContext = UIGraphicsGetCurrentContext()
    
    /*
        STYLING
    */
    let clockRadius = 0;
    //let clockCenter: CGPoint = CGPoint(x: rect.midx, y: rect.midy)
    let clockColor:CGColor = UIColor.green.cgColor

    
    
    
    init() {
        
        print("init-ed")
    }
    
    func getContext() -> CGContext { return self.clockContext!}
    
    func drawAnalogClock() -> UIView {
        
        clockView = Clock(frame: CGRect(x: 0, y: 0, width: 230, height: 230))
        
        let hourPath = CGMutablePath()
        let minutePath = CGMutablePath()
        let secondPath = CGMutablePath()
        
        
         //set names (is this needed? (no))
        // hourLayer.name = "hourHand"
        // minuteLayer.name = "minuteHand"
        // secondLayer.name = "secondHand"
        // centerPiece.name = "centerPiece"
        
        //set the views to the same size (is this needed? ?(yes)) [views are a little big tho...]
         hourLayer.frame = clockView.frame
         minuteLayer.frame = clockView.frame
         secondLayer.frame = clockView.frame
         
        
         
         //all hand shapes start in center
         hourPath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
         minutePath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
         secondPath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        
        //draw line straight up at specified lengths
         hourPath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-50))
         minutePath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-62.5))
         secondPath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-75))
         
         hourLayer.path = hourPath
         minuteLayer.path = minutePath
         secondLayer.path = secondPath
        
        //set line thicknesses
         hourLayer.lineWidth = 4
         minuteLayer.lineWidth = 3
         secondLayer.lineWidth = 1
        
        //set line ending
         //TODO: merge common variables here for easier customisation
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
         
         
         let endAngle = CGFloat(2*M_PI)
         
         let circle = UIBezierPath(arcCenter: CGPoint(x:clockView.frame.midX,y:clockView.frame.midX), radius: 2.75, startAngle: 0, endAngle: endAngle, clockwise: true)
         centerPiece.path = circle.cgPath
         centerPiece.fillColor = UIColor.gray.cgColor
         
         
         
         clockView.layer.addSublayer(hourLayer)
         clockView.layer.addSublayer(minuteLayer)
         clockView.layer.addSublayer(secondLayer)
         clockView.layer.addSublayer(centerPiece)
         

 
 
        return clockView
        
    }
    
    func updateHandsPosition(metricTime: (hour: Int, minute: Int, second: Int)) {
        
        setHandsAngle(handDegrees: getHandsPosition(metricTime: (hour: metricTime.hour, minute: metricTime.minute, second: metricTime.second)))
    }
    
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

    func getCurrentMetricTime(currentTime:DateComponents, shouldTick:Bool = false) -> (hour: Int, minute: Int, second: Int) {
        
        //why wont this work with smoothing out the clock...
        if !clockShouldTick {
            
            seconds = Double(currentTime.second!) + Double(currentTime.nanosecond!)/1000000000.0
            
            
            if let lastTimeCalled = lastCall //unwrap
            {
                //actualTime[2] += Int(0.0 * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0)
                seconds += 0.0 * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0
            }
            
            lastCall = Date()
            
        } else {
            
            seconds = Double(currentTime.second!)
        }

        
        
        //calculate metric "hours", "minutes", and "seconds"
        //var millisecondsSinceToday = Double(actualTime[0] * 3600000 /*milliseconds per hour*/) + Double(actualTime[1] * 60000 /* milliseconds per minute*/) + Double(self.seconds * 1000.0 /*milliseconds per second*/)
        var millisecondsSinceToday = Double(currentTime.hour! * 3600000 /*milliseconds per hour*/) + Double(currentTime.minute! * 60000 /* milliseconds per minute*/) + Double(seconds * 1000.0 /*milliseconds per second*/)

        
        
        metricTime.hour = Int(millisecondsSinceToday / 8640000)
         
        millisecondsSinceToday -= Double(metricTime.hour*8640000)
         
        metricTime.minute = Int(millisecondsSinceToday / 86400)
        
        millisecondsSinceToday -= Double(metricTime.minute*86400)
         
        metricTime.second = Int(millisecondsSinceToday / 864)
        convertedSeconds = Double(millisecondsSinceToday / 864) //?
        
        
        return metricTime
         
 
 
    }
    
    func convertTime(inputTime: (hour: Int, minute: Int, second: Int), toMetric:Bool = true) -> (hour: Int, minute: Int, second: Int) {
        
        var millisecondsSinceToday = 0
        var convertedTime = (hour: 0, minute: 0, second: 0)
        
        
        if toMetric {
            millisecondsSinceToday = (inputTime.hour * 3600000 /*milliseconds per hour*/) + (inputTime.minute * 60000 /* milliseconds per minute*/) + (inputTime.second * 1000 /*milliseconds per second*/)
        } else {
            millisecondsSinceToday = (inputTime.hour * 8640000 /*metric milliseconds per hour*/) + (inputTime.minute * 86400 /* metric milliseconds per minute*/) + (inputTime.second * 864 /*milliseconds per second*/)
        }
        
        
        convertedTime.hour = Int(millisecondsSinceToday / 8640000)
        millisecondsSinceToday -= (convertedTime.hour*8640000)
        
        convertedTime.minute = Int(millisecondsSinceToday / 86400)
        millisecondsSinceToday -= (convertedTime.minute*86400)
        
        convertedTime.second = Int(millisecondsSinceToday / 864)
        //screw milliseconds
        
        return convertedTime
    }
    
    
    
    
    private func getTickMarkLocations(clockView:UIView) -> [CGPoint] {
        let clockPoints = 100 /* total number of tick marks on the clock */
        var counter = clockPoints
        let tickSpacing = degree2radian(360/CGFloat(clockPoints))
        let clockCenter = (x: clockView.bounds.midX, y: clockView.bounds.midY)
        let clockRadius = clockView.bounds.width/2
        let adjustment:CGFloat = 0 //idk what this does, but i dont wanna remove it ciz' i may break the math...
        var points = [CGPoint]()
        
        
        while points.count <= clockPoints {
            //complex maths... dont touch...
            let xpo = clockCenter.x - clockRadius * cos(tickSpacing * CGFloat(counter)+degree2radian(adjustment))
            let ypo = clockCenter.y - clockRadius * sin(tickSpacing * CGFloat(counter)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            counter -= 1;
        }
        return points
        
    }
    
    func addTickMarks(points:[CGPoint]) {
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
    
    func addNumbers() {
        
        let inset = 5/16 //clockView.bounds.width/2 //determines spacing between numbers and tick marks
        
        
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        clockContext?.translateBy(x: 0.0, y: clockView.bounds.height)
        clockContext?.scaleBy(x: 1.0, y: -1.0)
    }
    
    
    /*
        Below this comment is a big, menny pile of copy-pasted, un-edited garbage </joke>
     
        I really need to make this cleaner and more readable...
     */

    //clock-drawing functionality from http://sketchytech.blogspot.co.uk/2014/11/swift-how-to-draw-clock-face-using_12.html
    
    func circleCircumferencePoints(_ sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            //complex maths... dont touch...
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1;
        }
        return points
    }
    
     func addMarkersandText(_ rect:CGRect, context:CGContext, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, sides2:Int, tickTextcolor:UIColor) {
     
        // retrieve points
        let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius)
        // create path
        let path1 = CGMutablePath()
        // determine length of marker as a fraction of the total radius
        var divider:CGFloat = 1/16
     
        //add the tick marks
        for p in points.enumerated() {
            if p.offset % 10 == 0 { //tick marks every 5
                divider = 2/16
            } else if p.offset % 5 == 0 { //tick marks every 10
                divider = 3/16
            } else {//tick marks every 1
                divider = 1/16
            }
     
            let xn = p.element.x + divider*(x-p.element.x)
            let yn = p.element.y + divider*(y-p.element.y)
            // build path
            //CGPathMoveToPoint(path1, nil, p.element.x, p.element.y)
            context.move(to: CGPoint(x: p.element.x, y: p.element.y))
            //CGPathAddLineToPoint(path1, nil, xn, yn)
            context.addLine(to: CGPoint(x: xn, y: yn))
            //path1.closeSubpath() //this breaks something
            // add path to context
            context.addPath(path1)
     
     
        }
     
        // set path color
        let cgcolor = tickTextcolor.cgColor
        context.setStrokeColor(cgcolor)
        context.setLineWidth(3.0)
        context.strokePath()
     
     
     
     
     
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        context.translateBy(x: 0.0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
     
        // dictates on how inset the ring of numbers will be
        let inset:CGFloat = radius/3.2
        // An adjustment of 270 degrees to position numbers correctly
        let textPoints = circleCircumferencePoints(sides2,x: x,y: y,radius: radius-inset,adjustment:270)
        // multiplier enables correcting numbering when fewer than 12 numbers are featured, e.g. 4 sides will display 12, 3, 6, 9
        let multiplier = 12/sides2
     
        for p in textPoints.enumerated() {
            if p.offset > 0 {
                // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
                let aFont = UIFont(name: "DamascusBold", size: radius/5)
                // create a dictionary of attributes to be applied to the string
                let attr:CFDictionary = [NSFontAttributeName:aFont!, NSForegroundColorAttributeName:tickTextcolor] as CFDictionary
                // create the attributed string
                let str = String(p.offset * multiplier)
                let text = CFAttributedStringCreate(nil, str as CFString!, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text!)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
                // set the line width to stroke the text with
                context.setLineWidth(1.5)
                // set the drawing mode to stroke
                context.setTextDrawingMode(CGTextDrawingMode.stroke)
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                context.textPosition = CGPoint(x: xn, y: yn)
                // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
                // draw the line of text
                CTLineDraw(line, context)
            }
        }
    }
    
    
  
    
    
    
}

class Clock: UIView {
    
    override func draw(_ rect: CGRect) {
        
        //do things as soon as a new Clock object is created?????
        
    }
    
}
