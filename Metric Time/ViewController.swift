//
//  ViewController.swift
//  Metric Time
//
//  Created by ACE on 2/15/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet var timeDisplay:UILabel?
    @IBOutlet var metricTimeDisplay:UILabel?
    
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    var longPressGestureRecognizerView: UIView!
    
    
    var components = NSCalendar.currentCalendar().components( [.Hour, .Minute, .Second], fromDate: NSDate())
    //var timer = NSTimer();
    
    private var displayLink:CADisplayLink?
    
    let color = UIColor.greenColor()
    let font = UIFont(name: "Calculator", size: 52.0)
    
    var stressTestMode = true
    var interval = 0
    var lastCall:NSDate?
    
    /**
     * Determines whether second hand sweeps or ticks
     */
    var continuous = false
    
    var seconds = 0.0
    var convertedSeconds = 0.0
    
    //  the actual time that normal humans use (in millitary time) (actualTime[0] = hour, actualTime[1] = minute, actualTime[2] = second)
    var actualTime: [Int] = [0, 0, 0]
    
    var millisecondsSinceToday:Double = 0.0
    
    //the converted "metric time"
    var metricTime: [Int] = [0, 0, 0]
    
    //variables for drawing hands
    var clockView = View();
    
    let hourLayer = CAShapeLayer()
    let minuteLayer = CAShapeLayer()
    let secondLayer = CAShapeLayer()
    let centerPiece = CAShapeLayer()
    
    func updateTime() {
        
        //get current hour, minute and second
        if !stressTestMode {
            components = NSCalendar.currentCalendar().components([ .Hour, .Minute, .Second, .Nanosecond], fromDate: NSDate())
            
            actualTime[0] = components.hour;
            actualTime[1] = components.minute;
            actualTime[2] = components.second;
            if self.continuous
            {
                self.seconds = Double(components.second) + Double(components.nanosecond)/1000000000.0
            }
            else
            {
                self.seconds = Double(components.second)
            }
            
        } else {
            
            //increment seconds
            if let lastTimeCalled = self.lastCall
            {
                actualTime[2] += Int(Double(interval) * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0)
                self.seconds += Double(interval) * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0
            }
            else
            {
                actualTime[2] += interval
            }
            self.lastCall = NSDate()
        }
        
        calculateMetricTime()
        
        //display updated values
        
        //update clock
        let positions = getHandsPosition(metricTime[0], m: metricTime[1], s: self.convertedSeconds)
        rotateHands(clockView, rotation: (positions.h, positions.m, positions.s) )
        
        
        //  decimalDay?.text = String(format: "%.5f", metricDecimalDay)
        timeDisplay?.text = String(format: "%02d : %02d : %02d", actualTime[0], actualTime[1], actualTime[2])
        metricTimeDisplay?.text = String(format: "%01d : %02d : %02d", metricTime[0], metricTime[1], metricTime[2])
        
        
        
        
        
        if stressTestMode {
            // log values
            print("ActualTime: \(actualTime[0]):\(actualTime[1]):\(actualTime[2])")
            print(" ")
            print("MetricTime: \(metricTime[0]):\(metricTime[1]):\(metricTime[2])")
            print(" ")
            print(" ")
        }
    }
    
    func calculateMetricTime() {
        
        /*calculate metric "hours", "minutes", and "seconds" */
        millisecondsSinceToday = 0.0
        millisecondsSinceToday = Double(actualTime[0] * 3600000 /*milliseconds per hour*/) + Double((actualTime[1] * 60000 /* milliseconds per minute*/)) + (self.seconds * 1000.0 /*milliseconds per second*/)
        
        
        metricTime[0] = Int(millisecondsSinceToday / 8640000)
        
        millisecondsSinceToday -= Double(metricTime[0]*8640000)
        
        metricTime[1] = Int(millisecondsSinceToday / 86400)
        
        millisecondsSinceToday -= Double(metricTime[1]*86400)
        
        metricTime[2] = Int(millisecondsSinceToday / 864)
        self.convertedSeconds = Double(millisecondsSinceToday / 864)
        
        
        
        
    }
    
    
    func rotateHands(view : UIView, rotation:(hour:CGFloat,minute:CGFloat,second:CGFloat)){
        
        hourLayer.transform = CATransform3DMakeRotation(rotation.hour, 0, 0, 1)
        minuteLayer.transform = CATransform3DMakeRotation(rotation.minute, 0, 0, 1)
        secondLayer.transform = CATransform3DMakeRotation(rotation.second, 0, 0, 1)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    func handleLongPressGestures(sender: UILongPressGestureRecognizer){
        
        print("long press detected.")
        self.performSegueWithIdentifier("moveToConversionView", sender: nil)
        longPressGestureRecognizerView.removeGestureRecognizer(longPressGestureRecognizer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        //longPressGestureRecognizerView = UIView.
        longPressGestureRecognizerView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
        /* First create the gesture recognizer */
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPressGestures(_:)))
        
        /* The number of fingers that must be present on the screen */
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        
        /* Maximum 100 points of movement allowed before the gesture is recognized */
        //longPressGestureRecognizer.allowableMovement = 50
        
        /* The user must press 2 fingers (numberOfTouchesRequired) for at least 1 second for the gesture to be recognized */
        longPressGestureRecognizer.minimumPressDuration = 2
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if stressTestMode {
            //adjust this to make stress test go faster or slower greater = faster second hand doesn't tick as such because the clock is going so fast that it just jumps around.
            interval = 50;
        }
        
        //load the font and color the text boxes
        timeDisplay?.font = font
        metricTimeDisplay?.font = font
        timeDisplay?.textColor = color
        metricTimeDisplay?.textColor = color
        
        //MARK: draw clock and hands...
        
        clockView = View(frame: CGRect(x: 0, y: 0, width: 230, height: 230))
        
        //position clock view
        
        self.view.addSubview(clockView)
        clockView.translatesAutoresizingMaskIntoConstraints = false
        clockView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: 0.0).active = false
        clockView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 15.0).active = true
        clockView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 0.0).active = true
        clockView.widthAnchor.constraintEqualToConstant(230.0).active = true
        clockView.heightAnchor.constraintEqualToConstant(230.0).active = true
        
        hourLayer.name = "hourHand"
        minuteLayer.name = "minuteHand"
        secondLayer.name = "secondHand"
        centerPiece.name = "centerPiece"
        
        hourLayer.frame = clockView.frame
        minuteLayer.frame = clockView.frame
        secondLayer.frame = clockView.frame
        
        let path = CGPathCreateMutable()
        let minutePath = CGPathCreateMutable()
        let secondPath = CGPathCreateMutable()
        
        //all hands start off in vertical position.
        CGPathMoveToPoint(path, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame))
        CGPathMoveToPoint(minutePath, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame))
        CGPathMoveToPoint(secondPath, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame))
        CGPathAddLineToPoint(path, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame)-50)
        CGPathAddLineToPoint(minutePath, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame)-62.5)
        CGPathAddLineToPoint(secondPath, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame)-75)
        
        hourLayer.path = path
        minuteLayer.path = minutePath
        secondLayer.path = secondPath
        
        hourLayer.lineWidth = 4
        minuteLayer.lineWidth = 3
        secondLayer.lineWidth = 1
        
        hourLayer.lineCap = kCALineCapRound
        minuteLayer.lineCap = kCALineCapRound
        secondLayer.lineCap = kCALineCapRound
        
        hourLayer.strokeColor = UIColor.whiteColor().CGColor
        minuteLayer.strokeColor = UIColor.whiteColor().CGColor
        secondLayer.strokeColor = UIColor.redColor().CGColor
        
        
        hourLayer.rasterizationScale = UIScreen.mainScreen().scale;
        minuteLayer.rasterizationScale = UIScreen.mainScreen().scale;
        secondLayer.rasterizationScale = UIScreen.mainScreen().scale;
        
        hourLayer.shouldRasterize = true
        minuteLayer.shouldRasterize = true
        secondLayer.shouldRasterize = true
        
        
        let endAngle = CGFloat(2*M_PI)
        
        let circle = UIBezierPath(arcCenter: CGPoint(x:CGRectGetMidX(clockView.frame),y:CGRectGetMidX(clockView.frame)), radius: 2.75, startAngle: 0, endAngle: endAngle, clockwise: true)
        centerPiece.path = circle.CGPath
        centerPiece.fillColor = UIColor.grayColor().CGColor
        
        
        
        clockView.layer.addSublayer(hourLayer)
        clockView.layer.addSublayer(minuteLayer)
        clockView.layer.addSublayer(secondLayer)
        clockView.layer.addSublayer(centerPiece)
        
        //add gesture recognizer to view
        longPressGestureRecognizerView.center = view.center
        view.addSubview(longPressGestureRecognizerView)
        
        /* Add this gesture recognizer to our view */
        longPressGestureRecognizerView.addGestureRecognizer(longPressGestureRecognizer)
        
        
        //by not calling updatetime() here, we get the cool aanimation of the clock setting the time after startup...
        
        
        //It is better to use an CADisplayLink for timing related to animation. This is why you have an issue with dropping ticks/frames. NSTimer executes when it's convenient for the run loop could be before or after the display has been rendered. CADisplayLink will always be executed prior to pixels being pushed to the screen. For more on this watch the video here: https://developer.apple.com/videos/play/wwdc2014/236/
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateTime))
        self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        //You can delete this timer code if you think displayLink will suit your needs
        //timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        //timer.tolerance = 0 //allow the timer to be off by a little if iOS needs it...
        
        
    }
    
    func getHandsPosition( h:Int, m:Int, s:Double)->(h:CGFloat,m:CGFloat,s:CGFloat) {
        
        
        var minutesAngle = (Double(m)/100 + Double(s)/10000.0)
        var hoursAngle = (Double(h)/10) + minutesAngle/10 //this line must come after minutesAngle Calculation...
        var secondsAngle = (Double(s)/100)
        
        hoursAngle = hoursAngle*360
        minutesAngle = minutesAngle*360
        secondsAngle = secondsAngle*360
        
        
        return (h: degree2radian(CGFloat(hoursAngle)),m: degree2radian(CGFloat(minutesAngle)),s: degree2radian(CGFloat(secondsAngle)))
    }
}


// MARK: Calculate coordinates of time


func circleCircumferencePoints(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
    let angle = degree2radian(360/CGFloat(sides))
    let cx = x // x origin
    let cy = y // y origin
    let r  = radius // radius of circle
    var i = sides
    var points = [CGPoint]()
    while points.count <= sides {
        let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
        let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
        points.append(CGPoint(x: xpo, y: ypo))
        i -= 1;
    }
    return points
}





func addMarkersandText(rect:CGRect, context:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, sides2:Int, tickTextcolor:UIColor) {
    
    // retrieve points
    let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius)
    // create path
    let path1 = CGPathCreateMutable()
    // determine length of marker as a fraction of the total radius
    var divider:CGFloat = 1/16
    
    //add the tick marks
    for p in points.enumerate() {
        //tick marks every 5
        if p.index % 10 == 0 {
            divider = 1/8
            
        }
            //tick marks every 10
        else if p.index % 5 == 0 {
            divider = 3/16
        }
            //tick marks every 1
        else {
            divider = 1/16
        }
        
        let xn = p.element.x + divider*(x-p.element.x)
        let yn = p.element.y + divider*(y-p.element.y)
        // build path
        CGPathMoveToPoint(path1, nil, p.element.x, p.element.y)
        CGPathAddLineToPoint(path1, nil, xn, yn)
        CGPathCloseSubpath(path1)
        // add path to context
        CGContextAddPath(context, path1)
        
        
    }
    
    // set path color
    let cgcolor = tickTextcolor.CGColor
    CGContextSetStrokeColorWithColor(context,cgcolor)
    CGContextSetLineWidth(context, 3.0)
    CGContextStrokePath(context)
    
    
    
    
    
    // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
    CGContextTranslateCTM(context, 0.0, CGRectGetHeight(rect))
    CGContextScaleCTM(context, 1.0, -1.0)
    
    // dictates on how inset the ring of numbers will be
    let inset:CGFloat = radius/3.2
    // An adjustment of 270 degrees to position numbers correctly
    let textPoints = circleCircumferencePoints(sides2,x: x,y: y,radius: radius-inset,adjustment:270)
    // multiplier enables correcting numbering when fewer than 12 numbers are featured, e.g. 4 sides will display 12, 3, 6, 9
    let multiplier = 12/sides2
    
    for p in textPoints.enumerate() {
        if p.index > 0 {
            // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
            let aFont = UIFont(name: "DamascusBold", size: radius/5)
            // create a dictionary of attributes to be applied to the string
            let attr:CFDictionaryRef = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:tickTextcolor]
            // create the attributed string
            let str = String(p.index*multiplier)
            let text = CFAttributedStringCreate(nil, str, attr)
            // create the line of text
            let line = CTLineCreateWithAttributedString(text)
            // retrieve the bounds of the text
            let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
            // set the line width to stroke the text with
            CGContextSetLineWidth(context, 1.5)
            // set the drawing mode to stroke
            CGContextSetTextDrawingMode(context, CGTextDrawingMode.Stroke)
            // Set text position and draw the line into the graphics context, text length and height is adjusted for
            let xn = p.element.x - bounds.width/2
            let yn = p.element.y - bounds.midY
            CGContextSetTextPosition(context, xn, yn)
            // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
            // draw the line of text
            CTLineDraw(line, context)
        }
    }
}



func degree2radian(a:CGFloat)->CGFloat {
    let b = CGFloat(M_PI) * a/180
    return b
}



class View: UIView {
    
    
    override func drawRect(rect:CGRect) {
        //assemble all pieces
        
        let context = UIGraphicsGetCurrentContext()
        
        // set properties
        
        
        let radius = CGRectGetWidth(rect)/2
        
        let endAngle = CGFloat(2*M_PI)
        
        //add circle
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), radius, 0, endAngle, 1)
        
        //set circle properties
        // CGContextSetFillColorWithColor(context,UIColor.grayColor().CGColor)
        //CGContextSetStrokeColorWithColor(context,UIColor.whiteColor().CGColor)
        // CGContextSetLineWidth(context, 4.0)
        
        //draw path
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke);
        
        addMarkersandText(rect, context: context!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: radius, sides: 100, sides2: 10, tickTextcolor: UIColor.greenColor())
        
    }
    
    
}


