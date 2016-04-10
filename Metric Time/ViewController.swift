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
    @IBOutlet var decimalDay:UILabel?
    @IBOutlet var metricTimeDisplay:UILabel?
    @IBOutlet var infoScreenButton:UIButton?
    
    
    var components = NSCalendar.currentCalendar().components( [.Hour, .Minute, .Second], fromDate: NSDate())
    var timer = NSTimer();
    
    
    let color = UIColor.greenColor();
    let font = UIFont(name: "Calculator", size: 52.0);
    
    var stressTestMode = false;
    var interval = 0.25;
    
    
    var deciday = 0; //(2h 24m)
    var centiday = 0;//(14m 24s)
    var milliday = 0;//(1m 26.4s)
    var microday = 0;//(86.4 ms)
    
    
    
    var metricDecimalDay:Float = 0 //shows how far you are through the day as a decimal (noon is .500000)
    
    //  the actual time that normal humans use (in millitary time) (actualTime[0] = hour, actualTime[1] = minute, actualTime[2] = second)
    var actualTime: [Int] = [0, 0, 0];
    
    //the converted "metric time"
    var metricTime: [Int] = [0, 0, 0];
    
    
    func updateTime() {
        //get current hour, minute and second
        if !stressTestMode {
            components = NSCalendar.currentCalendar().components([ .Hour, .Minute, .Second], fromDate: NSDate())
            
            actualTime[0] = components.hour;
            actualTime[1] = components.minute;
            actualTime[2] = components.second;
            
        } else {
            
            //increment seconds
            actualTime[2] += 1
            
            //if seconds = 60
             if actualTime[2] == 60 {
                //increment minutes and reset seconds
                
                actualTime[1] += 1
                actualTime[2] = 0
            }
            
            //if min = 60
             if actualTime[1] == 60 {
                //increment hours and reset minutes
                actualTime[0] += 1
                actualTime[1] = 0
            }
            
            //if hours = 24
             if actualTime[0] == 24 {
                //stop timer running.
                timer.invalidate()
                
            }
            
        }
        
        calculateMetricTime()
        
        //display updated values
        
        decimalDay?.text = String(format: "%.5f", metricDecimalDay)
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
        
                   //parts of day time here.
            
            metricDecimalDay = Float(Double(actualTime[0])/24) + Float(Double(actualTime[1])/1440) + Float(Double(actualTime[2])/86400)
            
            
            /*calculate metric "hours", "minutes", and "seconds"
             
                deciday = (int)(day * 10); milliday = (int)(day * 1000) % 100; msec = (int)(day * 100000) % 100;
            */
            
            metricTime[0] = Int(metricDecimalDay * 10)
            metricTime[1] = Int(metricDecimalDay * 1000) % 100
            metricTime[2] = Int(metricDecimalDay * 100000) % 100
            
            
            }
    
    
    
    
    func rotateLayer(currentLayer:CALayer,dur:CFTimeInterval){
        
        let angle = degree2radian(360)
        
        // rotation http://stackoverflow.com/questions/1414923/how-to-rotate-uiimageview-with-fix-point
        let theAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        theAnimation.duration = dur
        // Make this view controller the delegate so it knows when the animation starts and ends
        theAnimation.delegate = self
        theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // Use fromValue and toValue
        theAnimation.fromValue = 0
        theAnimation.repeatCount = Float.infinity
        theAnimation.toValue = angle
        
        // Add the animation to the layer
        currentLayer.addAnimation(theAnimation, forKey:"rotate")
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if stressTestMode {
            interval = 0.00001;
        }
        
        
        let endAngle = CGFloat(2*M_PI)
        
        
        let newView = View(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        //let horizontalCenterConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        //view.addConstraint(horizontalCenterConstraint)
        
        //let verticalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        //view.addConstraint(verticalConstraint)
        
        
        
        
        self.view.addSubview(newView)
        
        
        
        let time = timeCoords(CGRectGetMidX(newView.frame), y: CGRectGetMidY(newView.frame), time: ctime(),radius: 50)
        // Do any additional setup after loading the view, typically from a nib.
        // Hours
        let hourLayer = CAShapeLayer()
        hourLayer.frame = newView.frame
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, CGRectGetMidX(newView.frame), CGRectGetMidY(newView.frame))
        CGPathAddLineToPoint(path, nil, time.h.x, time.h.y)
        hourLayer.path = path
        hourLayer.lineWidth = 4
        hourLayer.lineCap = kCALineCapRound
        hourLayer.strokeColor = UIColor.blackColor().CGColor
        
        // see for rasterization advice http://stackoverflow.com/questions/24316705/how-to-draw-a-smooth-circle-with-cashapelayer-and-uibezierpath
        hourLayer.rasterizationScale = UIScreen.mainScreen().scale;
        hourLayer.shouldRasterize = true
        
        newView.layer.addSublayer(hourLayer)
        // time it takes for hour hand to pass through 360 degress
        rotateLayer(hourLayer,dur:86400)
        
        // Minutes
        let minuteLayer = CAShapeLayer()
        minuteLayer.frame = newView.frame
        let minutePath = CGPathCreateMutable()
        
        CGPathMoveToPoint(minutePath, nil, CGRectGetMidX(newView.frame), CGRectGetMidY(newView.frame))
        CGPathAddLineToPoint(minutePath, nil, time.m.x, time.m.y)
        minuteLayer.path = minutePath
        minuteLayer.lineWidth = 3
        minuteLayer.lineCap = kCALineCapRound
        minuteLayer.strokeColor = UIColor.whiteColor().CGColor
        
        minuteLayer.rasterizationScale = UIScreen.mainScreen().scale;
        minuteLayer.shouldRasterize = true
        
        newView.layer.addSublayer(minuteLayer)
        rotateLayer(minuteLayer,dur: 8640)
        
        
        // Seconds
        let secondLayer = CAShapeLayer()
        secondLayer.frame = newView.frame
        
        let secondPath = CGPathCreateMutable()
        CGPathMoveToPoint(secondPath, nil, CGRectGetMidX(newView.frame), CGRectGetMidY(newView.frame))
        CGPathAddLineToPoint(secondPath, nil, time.s.x, time.s.y)
        
        
        secondLayer.path = secondPath
        secondLayer.lineWidth = 1
        secondLayer.lineCap = kCALineCapRound
        secondLayer.strokeColor = UIColor.redColor().CGColor
        
        secondLayer.rasterizationScale = UIScreen.mainScreen().scale;
        
        secondLayer.shouldRasterize = true
        newView.layer.addSublayer(secondLayer)
        rotateLayer(secondLayer,dur: 100)
        let centerPiece = CAShapeLayer()
        
        let circle = UIBezierPath(arcCenter: CGPoint(x:CGRectGetMidX(newView.frame),y:CGRectGetMidX(newView.frame)), radius: 4.5, startAngle: 0, endAngle: endAngle, clockwise: true)
        // thanks to http://stackoverflow.com/a/19395006/1694526 for how to fill the color
        centerPiece.path = circle.CGPath
        centerPiece.fillColor = UIColor.whiteColor().CGColor
        newView.layer.addSublayer(centerPiece)
        
        
    
        
        
        
        
        
        
        //load the font and color the text boxes
        timeDisplay?.font = font
        decimalDay?.font = font
        metricTimeDisplay?.font = font
        timeDisplay?.textColor = color
        decimalDay?.textColor = color
        metricTimeDisplay?.textColor = color
        
        
        updateTime()
        
        
       // if NSUserDefaults.standardUserDefaults().boolForKey("useSplitDay") == true { let interval = 0.1; ) else { let interval =  }

        
        //set timer
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        timer.tolerance = 0.25 //allow the timer to be off by up to 0.25 seconds if iOS needs it...
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        timer.invalidate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}




















func degree2radian(a:CGFloat)->CGFloat {
    let b = CGFloat(M_PI) * a/180
    return b
}


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
func secondMarkers(ctx:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
    // retrieve points
    let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius)
    // create path
    let path = CGPathCreateMutable()
    // determine length of marker as a fraction of the total radius
    var divider:CGFloat = 1/16
    
    
    
    
    //add the tick marks
    for p in points.enumerate() {
        

        
        if p.index % 10 == 0 {
            divider = 1/8
            
        }
        else if p.index % 5 == 0 {
            divider = 3/16
        }
        else {
            divider = 1/16
        }
        
        let xn = p.element.x + divider*(x-p.element.x)
        let yn = p.element.y + divider*(y-p.element.y)
        // build path
        CGPathMoveToPoint(path, nil, p.element.x, p.element.y)
        CGPathAddLineToPoint(path, nil, xn, yn)
        CGPathCloseSubpath(path)
        // add path to context
        CGContextAddPath(ctx, path)
    }
    
    // set path color
    let cgcolor = color.CGColor
    CGContextSetStrokeColorWithColor(ctx,cgcolor)
    CGContextSetLineWidth(ctx, 3.0)
    CGContextStrokePath(ctx)
    
}

func drawText(rect:CGRect, ctx:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
    
    // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
    CGContextTranslateCTM(ctx, 0.0, CGRectGetHeight(rect))
    CGContextScaleCTM(ctx, 1.0, -1.0)
    // dictates on how inset the ring of numbers will be
    let inset:CGFloat = radius/3.25//3.5
    // An adjustment of 270 degrees to position numbers correctly
    let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius-inset,adjustment:270)
    _ = CGPathCreateMutable()
    // see
    for p in points.enumerate() {
        if p.index > 0 {
            // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
            let aFont = UIFont(name: "DamascusBold", size: radius/5)
            // create a dictionary of attributes to be applied to the string
            let attr:CFDictionaryRef = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:UIColor.whiteColor()]
            // create the attributed string
            let text = CFAttributedStringCreate(nil, p.index.description, attr)
            // create the line of text
            let line = CTLineCreateWithAttributedString(text)
            // retrieve the bounds of the text
            let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
            // set the line width to stroke the text with
            CGContextSetLineWidth(ctx, 1.5)
            // set the drawing mode to stroke
            CGContextSetTextDrawingMode(ctx, CGTextDrawingMode.FillStroke)
            // Set text position and draw the line into the graphics context, text length and height is adjusted for
            let xn = p.element.x - bounds.width/2
            let yn = p.element.y - bounds.midY
            CGContextSetTextPosition(ctx, xn, yn)
            // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
            // draw the line of text
            CTLineDraw(line, ctx)
        }
    }
    
}


class View: UIView {
    
    
    override func drawRect(rect:CGRect)
        
    {
        
        // obtain context
        let ctx = UIGraphicsGetCurrentContext()
        
        // decide on radius
        let rad = CGRectGetWidth(rect)/2.6//3.5
        
        let endAngle = CGFloat(2*M_PI)
        
        // add the circle to the context
        CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect), rad, 0, endAngle, 1)
        
        // set fill color
        CGContextSetFillColorWithColor(ctx,UIColor.grayColor().CGColor)
        
        // set stroke color
        CGContextSetStrokeColorWithColor(ctx,UIColor.whiteColor().CGColor)
        
        // set line width
        CGContextSetLineWidth(ctx, 4.0)
        // use to fill and stroke path (see http://stackoverflow.com/questions/13526046/cant-stroke-path-after-filling-it )
        
        // draw the path
        CGContextDrawPath(ctx,  CGPathDrawingMode.FillStroke);
        
        secondMarkers(ctx!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 100 /*60*/, color: UIColor.whiteColor())
        
        drawText(rect, ctx: ctx!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 10 /*12*/, color: UIColor.whiteColor())
        
        
        
        
    }
    
}




// MARK: Retrieve time
func ctime ()->(h:Int,m:Int,s:Int) {
    
    var t = time_t()

    time(&t)
    let x = localtime(&t) // returns UnsafeMutablePointer
    
    
    print(time_t())
    print(time(&t))
    print(Int(x.memory.tm_hour), " ", Int(x.memory.tm_min), " ", Int(x.memory.tm_sec))
    return (h:Int(x.memory.tm_hour),m:Int(x.memory.tm_min),s:Int(x.memory.tm_sec))
}
// END: Retrieve time

// MARK: Calculate coordinates of time
func  timeCoords(x:CGFloat,y:CGFloat,time:(h:Int,m:Int,s:Int),radius:CGFloat,adjustment:CGFloat=90)->(h:CGPoint, m:CGPoint,s:CGPoint) {
    let cx = x // x origin
    let cy = y // y origin
    var r  = radius // radius of circle
    var points = [CGPoint]()
    var angle = degree2radian(3.6)//6)
    func newPoint (t:Int) {
        let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(adjustment))
        let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(adjustment))
        points.append(CGPoint(x: xpo, y: ypo))
    }
    // work out hours first
    var hours = time.h
    if hours > 12 {
        hours = hours-12
    }
    let hoursInSeconds = time.h*3600 + time.m*60 + time.s
    newPoint(hoursInSeconds*5/3600)
    
    // work out minutes second
    r = radius * 1.25
    let minutesInSeconds = time.m*60 + time.s
    newPoint(minutesInSeconds/60)
    
    // work out seconds last
    r = radius * 1.5
    newPoint(time.s)
    
    return (h:points[0],m:points[1],s:points[2])
}
// END: Calculate coordinates of hour


enum NumberOfNumerals:Int {
    case two = 2, four = 4, twelve = 12
}


