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
    
    let RADIANS_IN_A_CIRCLE = 2*Double.pi
    
    
    
    //SETTINGS
    let CLOCK_TICKS = false //setting. not fully implemented

    
    //ANALOG CLOCK
    let clockContext:CGContext? = UIGraphicsGetCurrentContext() //why is this a constant?
    var clockView = Clock(frame: CGRect(x: 0, y: 0, width: 230, height: 230))

    
    //UI
    let CENTER_PIECE_RADIUS = 2.75
    
    let HOUR_HAND_THICKNESS = 4
    let MINUTE_HAND_THICKNESS = 3
    let SECOND_HAND_THICKNESS = 1
    
    let HOUR_HAND_LENGTH = 50
    let MINUTE_HAND_LENGTH = 62.5
    let SECOND_HAND_LENGTH = 75
    
    let HOUR_HAND_COLOR = UIColor.white.cgColor
    let MINUTE_HAND_COLOR = UIColor.white.cgColor
    let SECOND_HAND_COLOR = UIColor.red.cgColor
    let CENTER_PIECE_COLOR = UIColor.gray.cgColor
    
    //let clockViewRadius = 0;//unused
    let CLOCK_TEXT_COLOR:CGColor = UIColor.green.cgColor
    let NUMBER_FONT = UIFont(name: "DamascusBold", size: 23.0)//manually calculated size from radius/2
    let NUMBER_INSET:CGFloat = 3.2
    
    
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
        clockContext?.addArc(center: CGPoint(x: clockView.bounds.midX, y: clockView.bounds.midY), radius: clockView.bounds.width/2, startAngle: 0, endAngle: CGFloat(RADIANS_IN_A_CIRCLE), clockwise: true)
        
        clockContext?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        if clockContext != nil {
            clockContext!.setStrokeColor(UIColor.white.cgColor)
            clockContext!.setLineWidth(4.0)
        }
    }
    
    
    
    /// Calculates the x and y values for the specified number of points around the circle
    ///
    /// - parameter forNumbers: Boolean value that is used as a flag to indicate when calculating the points at which to render the numbers
    /// - returns: An array of CGPoint's
    private func getPointsOnCircle(forNumbers:Bool = false) -> [CGPoint] {
        
        var desiredNumberOfPoints = 100
        var inset:CGFloat = 0
        var adjustmentInRadians:CGFloat = 0 //this allows you to change the (rotation) position of the output points to adjust the text rendering

    
        if forNumbers {
            desiredNumberOfPoints = 10
            inset = (clockView.bounds.width/2)/NUMBER_INSET
            adjustmentInRadians = CGFloat(RADIANS_IN_A_CIRCLE) * CGFloat(-0.25) //one quarter of the circle
        }
        
        var counter = desiredNumberOfPoints //this must stay as is. dont remove the counter variable
        let tickSpacing = CGFloat(RADIANS_IN_A_CIRCLE)/CGFloat(desiredNumberOfPoints)
        let desiredPointRadius = (clockView.bounds.width/2)-inset //the difference between this and the actual radius of the clock is the inset value
        
        var points = [CGPoint]()
        
        while points.count < desiredNumberOfPoints {

            let x = clockView.bounds.midX - desiredPointRadius * cos(tickSpacing * CGFloat(counter) + adjustmentInRadians)
            let y = clockView.bounds.midY - desiredPointRadius * sin(tickSpacing * CGFloat(counter) + adjustmentInRadians)
            points.append(CGPoint(x: x, y: y))
            counter -= 1;
        }
       return points
        
    }

    /// Draws the tick marks on the clock face
    func addTickMarks() {
        let points = getPointsOnCircle()
        let tickPath = CGMutablePath()
        var tickLength: CGFloat
        
        for point in points.enumerated() {
            
            if point.offset % 10 == 0 {//if the "index" of the point is a multiple of 10
                tickLength = 2/16 //draw medium tick mark
            } else if point.offset % 5 == 0 {//if the "index" of the point is a multiple of 5
                tickLength = 3/16 //draw long tick mark
            } else {
                tickLength = 1/16 //draw short tick mark
            }
            
            
            let tickEndPoint = (x: point.element.x + tickLength*(clockView.bounds.midX - point.element.x), y: point.element.y + tickLength*(clockView.bounds.midY - point.element.y))
            
            clockContext?.move(to: CGPoint(x: point.element.x, y: point.element.y))
            clockContext?.addLine(to: CGPoint(x: tickEndPoint.x, y: tickEndPoint.y))
            clockContext?.addPath(tickPath)
            
        }
        
        clockContext?.setStrokeColor(CLOCK_TEXT_COLOR)
        clockContext?.setLineWidth(3.0)
        clockContext?.strokePath()
        
    }
    
    /// draws the numbers around the clock face
    func addNumbers() {
        
        
        let numberPositions = getPointsOnCircle(forNumbers: true)
        
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        clockContext?.translateBy(x: 0.0, y: clockView.bounds.height) //move down by its own height
        clockContext?.scaleBy(x: 1.0, y: -1.0)//flip in the Y direction over its top axis (presumably)
        
        let textAttributes = [NSFontAttributeName:NUMBER_FONT!, NSForegroundColorAttributeName:CLOCK_TEXT_COLOR] as CFDictionary
        
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
    
    
    
    /// creates and adds the hands of the clock as CALayer's to clockView
    /// - returns: a UIView object containing the layers of the hands
    func getHandLayers() -> (hourHand: CAShapeLayer, minuteHand: CAShapeLayer, secondHand: CAShapeLayer, center: CAShapeLayer) {
        
        let hourPath = CGMutablePath()
        let minutePath = CGMutablePath()
        let secondPath = CGMutablePath()
        
        //all hand shapes start in center
        hourPath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        minutePath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        secondPath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        
        //draw line straight up at specified lengths
        hourPath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY - CGFloat(HOUR_HAND_LENGTH)))
        minutePath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY - CGFloat(MINUTE_HAND_LENGTH)))
        secondPath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY - CGFloat(SECOND_HAND_LENGTH)))
        
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
        hourLayer.lineWidth = CGFloat(HOUR_HAND_THICKNESS)
        minuteLayer.lineWidth = CGFloat(MINUTE_HAND_THICKNESS)
        secondLayer.lineWidth = CGFloat(SECOND_HAND_THICKNESS)
        
        //set line ending
        hourLayer.lineCap = kCALineCapRound
        minuteLayer.lineCap = kCALineCapRound
        secondLayer.lineCap = kCALineCapRound
    
        
        //set color
        hourLayer.strokeColor = HOUR_HAND_COLOR
        minuteLayer.strokeColor = MINUTE_HAND_COLOR
        secondLayer.strokeColor = SECOND_HAND_COLOR
        
        
        hourLayer.rasterizationScale = UIScreen.main.scale;
        minuteLayer.rasterizationScale = UIScreen.main.scale;
        secondLayer.rasterizationScale = UIScreen.main.scale;
        
        hourLayer.shouldRasterize = true
        minuteLayer.shouldRasterize = true
        secondLayer.shouldRasterize = true
        
    
        //finally add the center piece
        
       // let circle = UIBezierPath(arcCenter: CGPoint(x:clockView.frame.midX,y:clockView.frame.midX), radius: 2.75, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        centerPiece.path = UIBezierPath(arcCenter: CGPoint(x:clockView.frame.midX,y:clockView.frame.midX), radius: CGFloat(CENTER_PIECE_RADIUS), startAngle: 0, endAngle: CGFloat(RADIANS_IN_A_CIRCLE), clockwise: true).cgPath
        centerPiece.fillColor = CENTER_PIECE_COLOR
        
        
        return (hourHand: hourLayer, minuteHand: minuteLayer, secondHand: secondLayer, center: centerPiece)
        
    }
    

    
    
    func updateHandsPosition(metricTime: (hour: Int, minute: Int, second: Int)) {
        setHandAngles(handAngles: calculateNewHandAngles(metricTime: metricTime))
    }
    
    func calculateNewHandAngles(metricTime: (hour: Int, minute: Int, second: Int)) -> (hourAngle:CGFloat, minuteAngle:CGFloat, secondAngle:CGFloat) {
        
        //example metric time: 5:25:16
        
        var secondsAngle = Double(metricTime.second)/100 // ADD MILLIS HERE // 16/100 = .16
        var minutesAngle = Double(metricTime.minute)/100 + secondsAngle/100 // 25/100 = .25; .16/100 = .0016; total: .2516
        var hoursAngle = Double(metricTime.hour)/10 + Double(metricTime.minute)/Double(MILLISECONDS_PER_SECOND) // 5/10 = .5; .25/10 = .025; total: .525 //seconds are insignificantly small
        
        //get the angle of the hands in degrees by multiplying the decimal/percentages by the total (360)
        hoursAngle = hoursAngle * Double(RADIANS_IN_A_CIRCLE) //.52516 * 360
        minutesAngle = minutesAngle * Double(RADIANS_IN_A_CIRCLE) //.2516 * 360
        secondsAngle = secondsAngle * Double(RADIANS_IN_A_CIRCLE) //.16 * 360
        
       //print(secondsAngle, minutesAngle, hoursAngle)
        
        
        return (hourAngle: CGFloat(hoursAngle), minuteAngle: CGFloat(minutesAngle), secondAngle: CGFloat(secondsAngle))
    }
    
    func setHandAngles(handAngles: (hourAngle:CGFloat, minuteAngle:CGFloat, secondAngle:CGFloat)) {
        let layers = self.getAnalogClock().layer.sublayers
        layers?[0].transform = CATransform3DMakeRotation(handAngles.hourAngle, 0, 0, 1)
        layers?[1].transform = CATransform3DMakeRotation(handAngles.minuteAngle, 0, 0, 1)
        layers?[2].transform = CATransform3DMakeRotation(handAngles.secondAngle, 0, 0, 1)
    }
    
    
    
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
    
    
    /// Calculates the x and y values for the specified number of points around the circle
    ///
    /// - parameter inputTime: The time to convert from in (hour: Int, minute: Int, second: Int) format
    /// - parameter toMetric: A boolean value that determines if thr functions should convert to metric or from metric. Defaults to true (AKA convert to metric)
    /// - returns: The converted time in (hour: Int, minute: Int, second: Int) format
    func convertTime(inputTime: (hour: Int, minute: Int, second: Int), toMetric:Bool = true) -> (hour: Int, minute: Int, second: Int) {
        
        var inputTimeMillis = 0
        var convertedTime = (hour: 0, minute: 0, second: 0)
        
        
        if toMetric {
            inputTimeMillis = (inputTime.hour * MILLISECONDS_PER_HOUR) + (inputTime.minute * MILLISECONDS_PER_MINUTE) + (inputTime.second * MILLISECONDS_PER_SECOND)
        } else {
            inputTimeMillis = (inputTime.hour * METRIC_MILLISECONDS_PER_HOUR) + (inputTime.minute * METRIC_MILLISECONDS_PER_MINUTE) + (inputTime.second * METRIC_MILLISECONDS_PER_SECOND)
        }
        
        convertedTime.hour = Int(inputTimeMillis / METRIC_MILLISECONDS_PER_HOUR)
        inputTimeMillis -= (convertedTime.hour * METRIC_MILLISECONDS_PER_HOUR)
        
        convertedTime.minute = Int(inputTimeMillis / METRIC_MILLISECONDS_PER_MINUTE)
        inputTimeMillis -= (convertedTime.minute * METRIC_MILLISECONDS_PER_MINUTE)
        
        convertedTime.second = Int(inputTimeMillis / METRIC_MILLISECONDS_PER_SECOND)
        //screw milliseconds, convertions dont need to be THAT accurate do they?
        
        return convertedTime
    }
    
}


class Clock: UIView {
    
    override func draw(_ rect: CGRect) {
        
        //do things as soon as a new Clock object is created?????
        
        let metricTime:MetricTime = MetricTime()
        
        metricTime.drawClockCircle()
        metricTime.addTickMarks()
        metricTime.addNumbers()
        
        let hands = metricTime.getHandLayers()
        
        self.layer.addSublayer(hands.hourHand)
        self.layer.addSublayer(hands.minuteHand)
        self.layer.addSublayer(hands.secondHand)
        self.layer.addSublayer(hands.center)
        
        
    }
    
}
