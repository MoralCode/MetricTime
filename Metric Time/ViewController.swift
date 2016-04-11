//
//  ViewController.swift
//  Metric Time
//
//  Created by ACE on 2/15/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import UIKit





class View: UIView {
    
    
    override func drawRect(rect:CGRect) {
        /*
         //get context
         let context = UIGraphicsGetCurrentContext()
         
         //set radius
         let radius = CGRectGetWidth(rect)/2.8
         
         let endAngle = CGFloat(2*M_PI)
         
         //add circle
         CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), radius, 0, endAngle, 1)
         
         
         //set properties
         CGContextSetFillColor(context, UIColor.grayColor().CGColor)
         CGContextSetStrokeColor(context, UIColor.whiteColor().CGColor)
         CGContextSetLineWidth(context, 4.0)
         
         //draw path
         CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
         
         //add markers
         secondMarkers(context!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: radius, sides: 100, color: UIColor.whiteColor())
         
         //add text
         drawText(rect, ctx: context!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: radius, sides: 10, color: UIColor.whiteColor())
         */
        
        
        
        
        
        
        
        
        
        // obtain context
        let ctx = UIGraphicsGetCurrentContext()
        
        // decide on radius
        let rad = CGRectGetWidth(rect)/2.8
        
        let endAngle = CGFloat(2*M_PI)
        
        // add the circle to the context
        CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect), rad, 0, endAngle, 1)
        
        // set fill color
        CGContextSetFillColorWithColor(ctx,UIColor.grayColor().CGColor)
        
        // set stroke color
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
        
        // set line width
        CGContextSetLineWidth(ctx, 4.0)
        // use to fill and stroke path (see http://stackoverflow.com/questions/13526046/cant-stroke-path-after-filling-it )
        
        // draw the path
        CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke);
        
        secondMarkers(ctx!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 60, color: UIColor.whiteColor())
        
        drawText(rect, ctx: ctx!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 12, color: UIColor.whiteColor())
        
        
    }
}








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
    var interval = 0.125;

    
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
        
    
        
        //Debug
        print("Seconds: \(millisecondsSinceToday / 864)")
        print("Seconds Modulus: \(millisecondsSinceToday % 864)")
        print("ActualTime: \(actualTime[0]):\(actualTime[1]):\(actualTime[2])")
        print("millisecondsSinceToday \(millisecondsSinceToday)") //correct
        print("MetricTime: \(metricTime[0]):\(metricTime[1]):\(metricTime[2])")
        
        print(" ")
        
            }
    
    
    

    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        let newView = View(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: CGRectGetWidth(self.view.frame)))
        
        self.view.addSubview(newView)
        
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
        
        
       // if NSUserDefaults.standardUserDefaults().boolForKey("useSplitDay") == true { let interval = 0.1; ) else { let interval =  }

        
        //set timer
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        timer.tolerance = 0.04 //allow the timer to be off by a little if iOS needs it...
        
        
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

//MARK: DRAW Circle


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

    
    
    
    //MARK: ANIMATE Hands
    








    }