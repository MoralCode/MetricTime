//
//  MetricClock.swift
//  Metric Time
//
//  Created by ACE on 12/21/17.
//  Copyright © 2017 Adrian Edwards. All rights reserved.
//

import Foundation
import UIKit

class MetricClock: UIView {
    
    
    let RADIANS_IN_A_CIRCLE = 2 * Double.pi
    
    
    //SETTINGS
    var tick = false
    let DEBUG = false
    
    
    //ANALOG CLOCK
    var clockContext:CGContext? = nil
    //var clockView = MetricClock(frame: CGRect(x: 0, y: 0, width: 230, height: 230))
    
    
    //UI
    
    var size = 0
    
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
    
    
    let METRIC_TIME = MetricTime()
    
    
    
    
    //-----------------------------------------------------------------------------------------------------
    //Constructors, Initializers, and UIView lifecycle
    //-----------------------------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    convenience init(size: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    convenience init(size: Int, tick: Bool) {
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.tick = tick
    }

    func didLoad() {
        //Place your initialization code here
        
        printDebugMsg(msg: "Bounds: " + String(describing: self.bounds))
        
        
        printDebugMsg(msg: "Add hands to Clock Face")
        let hands = getHandLayers()
        self.layer.addSublayer(hands.hourHand)
        self.layer.addSublayer(hands.minuteHand)
        self.layer.addSublayer(hands.secondHand)
        self.layer.addSublayer(hands.center)
    }
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        clockContext = UIGraphicsGetCurrentContext()
        
        //supposedly this is a memory leak according to instruments, but apparrently not https://stackoverflow.com/questions/4083712/c-c-string-memory-leaks#4083736
        printDebugMsg(msg: "CGContext: " + String(describing: clockContext))
        
        if (clockContext != nil) {
            printDebugMsg(msg: "Start drawing clock face")
            drawClockCircle(context: clockContext!)
            addTickMarks(context: clockContext!)
            addNumbers(context: clockContext!)

            printDebugMsg(msg: "Done drawing clock face")

        } else {
            print("No CGContext Available???")
        }
    }
    
    
    func updateTime() -> String {
        let currentMetricTime = METRIC_TIME.getCurrentMetricTime()
        updateHandsPositionToTime(metricTime: currentMetricTime)
        
        return String(format: "%01d : %02d : %02d", currentMetricTime.hour, currentMetricTime.minute, currentMetricTime.second)
    }
    
    
    
    func getCurrentDigitalTime() -> String {
        let currentMetricTime = METRIC_TIME.getCurrentMetricTime()
        return String(format: "%01d : %02d : %02d", currentMetricTime.hour, currentMetricTime.minute, currentMetricTime.second)
    }
    
    
    
    /// Draws and displays the Arc that makes up the curcumference of the clock face
    private func drawClockCircle(context:CGContext) {
        
        //draw the circle
        context.addArc(center: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: self.bounds.width/2, startAngle: 0, endAngle: CGFloat(RADIANS_IN_A_CIRCLE), clockwise: true)
        
        context.drawPath(using: CGPathDrawingMode.fillStroke)
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(4.0)
        
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
            inset = (self.bounds.width/2)/NUMBER_INSET
            adjustmentInRadians = CGFloat(RADIANS_IN_A_CIRCLE) * CGFloat(-0.25) //one quarter of the circle
        }
        
        var counter = desiredNumberOfPoints //this must stay as is. dont remove the counter variable
        let tickSpacing = CGFloat(RADIANS_IN_A_CIRCLE)/CGFloat(desiredNumberOfPoints)
        let desiredPointRadius = (self.bounds.width/2)-inset //the difference between this and the actual radius of the clock is the inset value
        
        var points = [CGPoint]()
        
        while points.count < desiredNumberOfPoints {
            
            let x = self.bounds.midX - desiredPointRadius * cos(tickSpacing * CGFloat(counter) + adjustmentInRadians)
            let y = self.bounds.midY - desiredPointRadius * sin(tickSpacing * CGFloat(counter) + adjustmentInRadians)
            points.append(CGPoint(x: x, y: y))
            counter -= 1;
        }
        return points
        
    }
    
    /// Draws the tick marks on the clock face
    private func addTickMarks(context: CGContext) {
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
            
            
            let tickEndPoint = (x: point.element.x + tickLength*(self.bounds.midX - point.element.x), y: point.element.y + tickLength*(self.bounds.midY - point.element.y))
            
            context.move(to: CGPoint(x: point.element.x, y: point.element.y))
            context.addLine(to: CGPoint(x: tickEndPoint.x, y: tickEndPoint.y))
            context.addPath(tickPath)
            
        }
        
        context.setStrokeColor(CLOCK_TEXT_COLOR)
        context.setLineWidth(3.0)
        context.strokePath()
        
    }
    
    /// draws the numbers around the clock face
   private func addNumbers(context:CGContext) {
        
        
        let numberPositions = getPointsOnCircle(forNumbers: true)
        
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        context.translateBy(x: 0.0, y: self.bounds.height) //move down by its own height
        context.scaleBy(x: 1.0, y: -1.0)//flip in the Y direction over its top axis (presumably)
        
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
            context.setLineWidth(1.5)
            
            // set the drawing mode to stroke
            context.setTextDrawingMode(CGTextDrawingMode.stroke)
            
            // Set text position and draw the line into the graphics context, text length and height is adjusted for
            let xn = point.element.x - bounds.width/2
            let yn = point.element.y - bounds.midY
            
            context.textPosition = CGPoint(x: xn, y: yn)
            
            // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
            
            
                CTLineDraw(line, context)
            
        }
        
        
    }
    
    
    
    /// creates and adds the hands of the clock as CALayer's to clockView
    /// - returns: a UIView object containing the layers of the hands
    private func getHandLayers() -> (hourHand: CAShapeLayer, minuteHand: CAShapeLayer, secondHand: CAShapeLayer, center: CAShapeLayer) {
        
        let hourPath = CGMutablePath()
        let minutePath = CGMutablePath()
        let secondPath = CGMutablePath()
        
        //all hand shapes start in center
        hourPath.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY))
        minutePath.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY))
        secondPath.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY))
        
        //draw line straight up at specified lengths
        hourPath.addLine(to: CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(HOUR_HAND_LENGTH)))
        minutePath.addLine(to: CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(MINUTE_HAND_LENGTH)))
        secondPath.addLine(to: CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(SECOND_HAND_LENGTH)))
        
        //layers are then rotated from these vertical positions
        
        
        let hourLayer = CAShapeLayer()
        let minuteLayer = CAShapeLayer()
        let secondLayer = CAShapeLayer()
        let centerPiece = CAShapeLayer()
        
        //set the views to the same size [views are a little big tho...]?
        hourLayer.frame = self.frame
        minuteLayer.frame = self.frame
        secondLayer.frame = self.frame
        
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
        
        if (DEBUG) {
            hourLayer.backgroundColor = UIColor.green.cgColor
            minuteLayer.backgroundColor = UIColor.red.cgColor
            secondLayer.backgroundColor = UIColor.blue.cgColor
        }
        
        hourLayer.rasterizationScale = UIScreen.main.scale;
        minuteLayer.rasterizationScale = UIScreen.main.scale;
        secondLayer.rasterizationScale = UIScreen.main.scale;
        
        hourLayer.shouldRasterize = true
        minuteLayer.shouldRasterize = true
        secondLayer.shouldRasterize = true
        
        
        //finally add the center piece
        
        // let circle = UIBezierPath(arcCenter: CGPoint(x:clockView.frame.midX,y:clockView.frame.midX), radius: 2.75, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        centerPiece.path = UIBezierPath(arcCenter: CGPoint(x: self.frame.midX,y: self.frame.midX), radius: CGFloat(CENTER_PIECE_RADIUS), startAngle: 0, endAngle: CGFloat(RADIANS_IN_A_CIRCLE), clockwise: true).cgPath
        centerPiece.fillColor = CENTER_PIECE_COLOR
        
        return (hourHand: hourLayer, minuteHand: minuteLayer, secondHand: secondLayer, center: centerPiece)
        
    }
    
    
    
    
    private func updateHandsPositionToTime(metricTime: (hour: Int, minute: Int, second: Int, millisecond: Int)) {
        setHandAngles(handAngles: calculateNewHandAngles(metricTime: metricTime))
    }
    
    //func updateHandsPosition() {
   //     updateHandsPositionToTime(metricTime: METRIC_TIME.getCurrentMetricTime())
    //}
    
    private func calculateNewHandAngles(metricTime: (hour: Int, minute: Int, second: Int, millisecond: Int)) -> (hourAngle:CGFloat, minuteAngle:CGFloat, secondAngle:CGFloat) {
        
        //example metric time: 5:25:16
        
        
        //TODO: Do something with milliseconds here maybe???
        
        var secondsAngle = Double(metricTime.second)/100  // 16/100 = .16
        if (tick) {secondsAngle += Double(metricTime.millisecond)/100000}
        var minutesAngle = Double(metricTime.minute)/100 + secondsAngle/100 // 25/100 = .25; .16/100 = .0016; total: .2516
        var hoursAngle = Double(metricTime.hour)/10 + minutesAngle/10 // 5/10 = .5; .25/10 = .025; total: .525 //seconds are insignificantly small
        
        printDebugMsg(msg: "Hours Percentage: " + String(hoursAngle))
        printDebugMsg(msg: "Minutes Percentage: " + String(minutesAngle))
        printDebugMsg(msg: "Seconds Percentage: " + String(secondsAngle))
        
        //get the angle of the hands in degrees by multiplying the decimal/percentages by the total (360)
        hoursAngle = hoursAngle * Double(RADIANS_IN_A_CIRCLE) //.52516 * 360
        minutesAngle = minutesAngle * Double(RADIANS_IN_A_CIRCLE) //.2516 * 360
        secondsAngle = secondsAngle * Double(RADIANS_IN_A_CIRCLE) //.16 * 360
        
        return (hourAngle: CGFloat(hoursAngle), minuteAngle: CGFloat(minutesAngle), secondAngle: CGFloat(secondsAngle))
    }
    
   private func setHandAngles(handAngles: (hourAngle:CGFloat, minuteAngle:CGFloat, secondAngle:CGFloat)) {
        let layers = self.layer.sublayers
        layers?[0].transform = CATransform3DMakeRotation(handAngles.hourAngle, 0, 0, 1)
        layers?[1].transform = CATransform3DMakeRotation(handAngles.minuteAngle, 0, 0, 1)
        layers?[2].transform = CATransform3DMakeRotation(handAngles.secondAngle, 0, 0, 1)
    }
    
    ///prints a message if the DEBUG constant is true
    private func printDebugMsg(msg: Any) {
        if (DEBUG) {print(msg)}
    }
    
    
}
