//
//  ViewController.swift
//  Metric Time
//
//  Created by ACE on 2/15/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import UIKit

//enum NumberOfNumerals:Int {
//    case two = 2, four = 4, twelve = 12
//}


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
    var interval = 0.2;

    
    //  the actual time that normal humans use (in millitary time) (actualTime[0] = hour, actualTime[1] = minute, actualTime[2] = second)
    var actualTime: [Int] = [0, 0, 0];
    
    var millisecondsSinceToday = 0;
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
        
        //update clock
        
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
        millisecondsSinceToday = 0
        millisecondsSinceToday = (actualTime[0] * 3600000 /*milliseconds per hour*/) + (actualTime[1] * 60000 /* milliseconds per minute*/) + (actualTime[2] * 1000 /*milliseconds per second*/)
        
        
        //print(Double(millisecondsSinceToday / 8640000))
      
        
        
        metricTime[0] = Int(millisecondsSinceToday / 8640000)//correct

        millisecondsSinceToday -= (metricTime[0]*8640000)
        
        metricTime[1] = Int(millisecondsSinceToday / 86400)//correct
        
        millisecondsSinceToday -= (metricTime[1]*86400)
        
        metricTime[2] = Int(millisecondsSinceToday / 864)
        

    
        
            }
    
    
    func rotate(view : UIView, duration : Double, rotation : CGFloat, amount:Double, reps : Float){
        
        let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotationAnimation.toValue = CGFloat( amount * (M_PI * 2.0))
        rotationAnimation.duration = duration
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = reps
        
        view.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        view.layer.sublayerTransform = CATransform3DMakeRotation( CGFloat(M_PI) , 160, 160, 1)//* percentageSecondsIntoMinute,
    }

    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
       
        if stressTestMode {
            interval = 0.00001;
        }
        
        
        
        //load the font and color the text boxes
        timeDisplay?.font = font
        decimalDay?.font = font
        metricTimeDisplay?.font = font
        timeDisplay?.textColor = color
        decimalDay?.textColor = color
        metricTimeDisplay?.textColor = color
        
        
        updateTime()

        
        //MARK: draw clock and hands...
        
        let clockView = View(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))

        //let time = getHandsPosition(CGRectGetMidX(clockView.frame), y: CGRectGetMidY(clockView.frame), time: (h: 00, m: 0, s:0/*metricTime[0], m: metricTime[1], s: metricTime[2]*/),radius: 50)
        
        // Hours
        let hourLayer = CAShapeLayer()
        let minuteLayer = CAShapeLayer()
        let secondLayer = CAShapeLayer()
        let centerPiece = CAShapeLayer()
        
        
        hourLayer.frame = clockView.frame
        minuteLayer.frame = clockView.frame
        secondLayer.frame = clockView.frame
        
        let path = CGPathCreateMutable()
        let minutePath = CGPathCreateMutable()
        let secondPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame))
        CGPathMoveToPoint(minutePath, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame))
        CGPathMoveToPoint(secondPath, nil, CGRectGetMidX(clockView.frame), CGRectGetMidY(clockView.frame))
        
        //all hands start off in vertical position.
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

        
        
        
        self.view.addSubview(clockView)
        clockView.layer.addSublayer(hourLayer)
        clockView.layer.addSublayer(minuteLayer)
        clockView.layer.addSublayer(secondLayer)
        clockView.layer.addSublayer(centerPiece)
    

        
        rotate(clockView, duration: 10, rotation: 90, amount: 1, reps: 1)
        
        
        
        
        
        
        
       // if NSUserDefaults.standardUserDefaults().boolForKey("useSplitDay") == true { let interval = 0.1; ) else { let interval =  }

        
        //set timer
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        timer.tolerance = 0 //allow the timer to be off by a little if iOS needs it...
        
        
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











// MARK: Calculate coordinates of time
func getHandsPosition(x:CGFloat,y:CGFloat,time:(h:Int,m:Int,s:Int),radius:CGFloat,adjustment:CGFloat=90)->(h:CGPoint, m:CGPoint,s:CGPoint) {
    let cx = x // x origin
    let cy = y // y origin
    var r  = radius // radius of circle
    var points = [CGPoint]()
    var angle = degree2radian(10)
    func newPoint (t:Int) {
        let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(adjustment))
        let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(adjustment))
        points.append(CGPoint(x: xpo, y: ypo))
    }
    
    let secondsInMin = 100
    let minutesInHour = 100
    
    
    
    
    
    
    
    
    
//    
//        - (void)updateHands {
//            NSDate *now = [NSDate date];
//            NSCalendar *cal = [NSCalendar currentCalendar];
//            NSDateComponents *comps = [cal components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
//            
//            NSInteger minutesIntoDay = [comps hour] * 60 + [comps minute];
//            float percentageMinutesIntoDay = minutesIntoDay / (12.0 * 60.0);
//            float percentageMinutesIntoHour = (float)[comps minute] / 60.0;
//            float percentageSecondsIntoMinute = (float)[comps second] / 60.0;
//            
//            secondHand_.transform = CATransform3DMakeRotation((M_PI * 2) * percentageSecondsIntoMinute, 0, 0, 1);
//            minuteHand_.transform = CATransform3DMakeRotation((M_PI * 2) * percentageMinutesIntoHour, 0, 0, 1);
//            hourHand_.transform = CATransform3DMakeRotation((M_PI * 2) * percentageMinutesIntoDay, 0, 0, 1);
//    }
    
    
    //calculate hours
    
    let hoursInSeconds = time.h*(secondsInMin*minutesInHour) + time.m*secondsInMin + time.s
    newPoint(hoursInSeconds*5/(secondsInMin*minutesInHour))
    print(hoursInSeconds*5/(secondsInMin*minutesInHour))
    
    // work out minutes second
    r = radius * 1.25
    let minutesInSeconds = time.m*secondsInMin + time.s
    newPoint(minutesInSeconds/secondsInMin)
    print(minutesInSeconds/secondsInMin)
    
    // work out seconds last
    r = radius * 1.5
    newPoint(time.s)
    print(time.s)
//    print(points[0])
//    print(points[1])
//    print(points[2])
    return (h:points[0],m:points[1],s:points[2])
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
    

        let radius = CGRectGetWidth(rect)/2.8

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


