//
//  ViewController.swift
//  Metric Time
//
//  Created by ACE on 2/15/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var metricTimeDisplay:UILabel?
    
    var gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
   // var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: nil, action: <#T##Selector?#>)
    
    var components = (Calendar.current as NSCalendar).components( [.hour, .minute, .second], from: Date())
    //var timer = NSTimer();
    
    fileprivate var displayLink:CADisplayLink?
    var lastCall:Date?
    
    let color = UIColor.green;
    let font = UIFont(name: "Calculator", size: 52.0);
    
    
    //  the actual time that normal humans use (in millitary time) (actualTime[0] = hour, actualTime[1] = minute, actualTime[2] = second)
    var actualTime: [Int] = [0, 0, 0];
    
    var millisecondsSinceToday:Double = 0.0;
    
    //the converted "metric time"
    var metricTime: [Int] = [0, 0, 0];
    var seconds = 0.0
    var convertedSeconds = 0.0
    //variables for drawing hands
    var clockView = View();
    
    
    let hourLayer = CAShapeLayer()
    let minuteLayer = CAShapeLayer()
    let secondLayer = CAShapeLayer()
    let centerPiece = CAShapeLayer()
    
    
    
    
    
    
    func updateTime() {
        
        //get current hour, minute and second
        
        components = (Calendar.current as NSCalendar).components([ .hour, .minute, .second, .nanosecond], from: Date())
        
        actualTime[0] = components.hour!;
        actualTime[1] = components.minute!;
        actualTime[2] = components.second!;
        self.seconds = Double(components.second!) + Double(components.nanosecond!)/1000000000.0
        
        
        if let lastTimeCalled = self.lastCall
        {
            actualTime[2] += Int(0.0 * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0)
            self.seconds += 0.0 * lastTimeCalled.timeIntervalSinceNow * 60.0 * -1.0
        }
        else
        {
            actualTime[2] += 0
        }

        self.lastCall = Date()
        
        calculateMetricTime()
        
        
        //update clock
        let positions = getHandsPosition(metricTime[0], m: metricTime[1], s: self.convertedSeconds)
        rotateHands(clockView, rotation: (positions.h, positions.m, positions.s) )
        
        metricTimeDisplay?.text = String(format: "%01d : %02d : %02d", metricTime[0], metricTime[1], metricTime[2])
        
        
        
    }
    
    func calculateMetricTime() {
        
        /*calculate metric "hours", "minutes", and "seconds" */
        millisecondsSinceToday = 0.0
        millisecondsSinceToday = Double(actualTime[0] * 3600000 /*milliseconds per hour*/) + Double(actualTime[1] * 60000 /* milliseconds per minute*/) + Double(self.seconds * 1000.0 /*milliseconds per second*/)
        
        
        metricTime[0] = Int(millisecondsSinceToday / 8640000)
        
        millisecondsSinceToday -= Double(metricTime[0]*8640000)
        
        metricTime[1] = Int(millisecondsSinceToday / 86400)
        
        millisecondsSinceToday -= Double(metricTime[1]*86400)
        
        metricTime[2] = Int(millisecondsSinceToday / 864)
        self.convertedSeconds = Double(millisecondsSinceToday / 864)
        
        
        
    }
    
    
    
    
    func rotateHands(_ view : UIView, rotation:(hour:CGFloat,minute:CGFloat,second:CGFloat)){
        
        hourLayer.transform = CATransform3DMakeRotation(rotation.hour, 0, 0, 1)
        minuteLayer.transform = CATransform3DMakeRotation(rotation.minute, 0, 0, 1)
        secondLayer.transform = CATransform3DMakeRotation(rotation.second, 0, 0, 1)
        
    }
    
    
    
    override var prefersStatusBarHidden : Bool {
        return true
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
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//
//        print("coder")
//
//        /* First create the gesture recognizer */
//        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPressGestures(_:)))
//        
//        /* The number of fingers that must be present on the screen */
//        longPressGestureRecognizer.numberOfTouchesRequired = 1
//        
//        /* Maximum 100 points of movement allowed before the gesture is recognized */
//        //longPressGestureRecognizer.allowableMovement = 50
//        
//        /* The user must press 2 fingers (numberOfTouchesRequired) for at least 1 second for the gesture to be recognized */
//        longPressGestureRecognizer.minimumPressDuration = 2
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        //re-add the gesture recognizer so the convertion screen can be re-accessed...
        view.addGestureRecognizer(gesture)
       // clockView.addGestureRecognizer(gesture)
      //  metricTimeDisplay?.addGestureRecognizer(gesture)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        //load the font and color the text boxes
        metricTimeDisplay?.font = font
        metricTimeDisplay?.textColor = color
        
        gesture.addTarget(self, action: #selector(ViewController.handleGesture))
        
        
        
        
        //MARK: draw clock and hands...
        
        clockView = View(frame: CGRect(x: 0, y: 0, width: 230, height: 230))
        
        view.isUserInteractionEnabled = true
        
        //position clock view
        
        self.view.addSubview(clockView)
        clockView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            clockView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = false
            
            clockView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15.0).isActive = true
            clockView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
            clockView.widthAnchor.constraint(equalToConstant: 230.0).isActive = true
            clockView.heightAnchor.constraint(equalToConstant: 230.0).isActive = true
        } else {
            //TODO: Fallback on earlier versions
        }
        
        
        
        
        
        
        
        hourLayer.name = "hourHand"
        minuteLayer.name = "minuteHand"
        secondLayer.name = "secondHand"
        centerPiece.name = "centerPiece"
        
        hourLayer.frame = clockView.frame
        minuteLayer.frame = clockView.frame
        secondLayer.frame = clockView.frame
        
        let path = CGMutablePath()
        let minutePath = CGMutablePath()
        let secondPath = CGMutablePath()
        
        //all hands start off in vertical position.
        path.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        minutePath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        secondPath.move(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY))
        
        path.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-50))
        minutePath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-62.5))
        secondPath.addLine(to: CGPoint(x: clockView.frame.midX, y: clockView.frame.midY-75))
        
        hourLayer.path = path
        minuteLayer.path = minutePath
        secondLayer.path = secondPath
        
        hourLayer.lineWidth = 4
        minuteLayer.lineWidth = 3
        secondLayer.lineWidth = 1
        
        hourLayer.lineCap = kCALineCapRound
        minuteLayer.lineCap = kCALineCapRound
        secondLayer.lineCap = kCALineCapRound
        
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
        

        
        //by not calling updatetime() here, we get the cool aanimation of the clock setting the time after startup...
        
        
        //It is better to use an CADisplayLink for timing related to animation. This is why you have an issue with dropping ticks/frames.
        //NSTimer executes when it's convenient for the run loop could be before or after the display has been rendered. CADisplayLink will always be executed prior to pixels being pushed to the screen. For more on this watch the video here: https://developer.apple.com/videos/play/wwdc2014/236/
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateTime))
        self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
        
    }
}


// MARK: Calculate coordinates of time
func getHandsPosition( _ h:Int, m:Int, s:Double)->(h:CGFloat,m:CGFloat,s:CGFloat) {
    
    
    var minutesAngle = (Double(m)/100 + Double(s)/10000.0)
    var hoursAngle = (Double(h)/10) + minutesAngle/10 //this line must come after minutesAngle Calculation...
    var secondsAngle = (Double(s)/100)
    
    hoursAngle = hoursAngle*360
    minutesAngle = minutesAngle*360
    secondsAngle = secondsAngle*360
    
    
    return (h: degree2radian(CGFloat(hoursAngle)),m: degree2radian(CGFloat(minutesAngle)),s: degree2radian(CGFloat(secondsAngle)))
}

func circleCircumferencePoints(_ sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
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





func addMarkersandText(_ rect:CGRect, context:CGContext, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, sides2:Int, tickTextcolor:UIColor) {
    
    // retrieve points
    let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius)
    // create path
    let path1 = CGMutablePath()
    // determine length of marker as a fraction of the total radius
    var divider:CGFloat = 1/16
    
    //add the tick marks
    for p in points.enumerated() {
        //tick marks every 5
        if p.offset % 10 == 0 {
            divider = 1/8
            
        }
            //tick marks every 10
        else if p.offset % 5 == 0 {
            divider = 3/16
        }
            //tick marks every 1
        else {
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



func degree2radian(_ a:CGFloat)->CGFloat {
    let b = CGFloat(M_PI) * a/180
    return b
}



class View: UIView {
    
    
    override func draw(_ rect:CGRect) {
        //assemble all pieces
        
        let context = UIGraphicsGetCurrentContext()
        
        // set properties
        
        
        let radius = rect.width/2
        
        let endAngle = CGFloat(2*M_PI)
        
        //add circle
       // CGContextAddArc(context, , radius, 0, endAngle, 1)
        context?.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        
        //set circle properties
        // CGContextSetFillColorWithColor(context,UIColor.grayColor().CGColor)
        //CGContextSetStrokeColorWithColor(context,UIColor.whiteColor().CGColor)
        // CGContextSetLineWidth(context, 4.0)
        
        //draw path
        context?.drawPath(using: CGPathDrawingMode.fillStroke);
        
        addMarkersandText(rect, context: context!, x: rect.midX, y: rect.midY, radius: radius, sides: 100, sides2: 10, tickTextcolor: UIColor.green)
        
    }
    
    
}


