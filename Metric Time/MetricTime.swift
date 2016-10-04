//
//  MetricTime.swift
//  Metric Time
//
//  Created by ACE on 9/29/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//



/* This file contains the
 
 
 */

import Foundation
import UIKit

class MetricTime {
    
    let hourLayer = CAShapeLayer()
    let minuteLayer = CAShapeLayer()
    let secondLayer = CAShapeLayer()
    let centerPiece = CAShapeLayer()
    


    
   public func drawAnalogClock(width:CGFloat = 230, height:CGFloat = 230) -> UIView {
        
        var clockView = View(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
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
    
    
    func setHandsAngle(hour:CGFloat, minute:CGFloat, second:CGFloat) {
        
         hourLayer.transform = CATransform3DMakeRotation(hour, 0, 0, 1)
         minuteLayer.transform = CATransform3DMakeRotation(minute, 0, 0, 1)
         secondLayer.transform = CATransform3DMakeRotation(second, 0, 0, 1)
        
        
    }

    
    
    
    func getCurrentMetricTime() {
        
        /*
         //calculate metric "hours", "minutes", and "seconds"
         millisecondsSinceToday = 0.0
         millisecondsSinceToday = Double(actualTime[0] * 3600000 /*milliseconds per hour*/) + Double(actualTime[1] * 60000 /* milliseconds per minute*/) + Double(self.seconds * 1000.0 /*milliseconds per second*/)
         
         
         metricTime[0] = Int(millisecondsSinceToday / 8640000)
         
         millisecondsSinceToday -= Double(metricTime[0]*8640000)
         
         metricTime[1] = Int(millisecondsSinceToday / 86400)
         
         millisecondsSinceToday -= Double(metricTime[1]*86400)
         
         metricTime[2] = Int(millisecondsSinceToday / 864)
         self.convertedSeconds = Double(millisecondsSinceToday / 864)
         
 
 */
    }
    
    
    
    func convertToMetricTime(_ time:[Int]) -> [Int] {
        
        var millisecondsSinceToday = (time[0] * 3600000 /*milliseconds per hour*/) + (time[1] * 60000 /* milliseconds per minute*/) + (time[2] * 1000 /*milliseconds per second*/)
        
        var convertedTime: [Int] = [0, 0, 0];
        
        convertedTime[0] = Int(millisecondsSinceToday / 8640000)
        millisecondsSinceToday -= (convertedTime[0]*8640000)
        convertedTime[1] = Int(millisecondsSinceToday / 86400)
        millisecondsSinceToday -= (convertedTime[1]*86400)
        convertedTime[2] = Int(millisecondsSinceToday / 864)
        
        
        return convertedTime
    }
    
    
    func convertToNormalTime(_ time:[Int]) -> [Int] {
        
        var millisecondsSinceToday = (time[0] * 8640000 /*metric milliseconds per hour*/) + (time[1] * 86400 /* metric milliseconds per minute*/) + (time[2] * 864 /*milliseconds per second*/)
        
        var convertedTime: [Int] = [0, 0, 0];
        
        convertedTime[0] = Int(millisecondsSinceToday / 3600000)
        millisecondsSinceToday -= (convertedTime[0]*3600000)
        convertedTime[1] = Int(millisecondsSinceToday / 60000)
        millisecondsSinceToday -= (convertedTime[1]*60000)
        convertedTime[2] = Int(millisecondsSinceToday / 1000)
        
        
        return convertedTime
    }
    
    /*
 
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

 
 */

}
