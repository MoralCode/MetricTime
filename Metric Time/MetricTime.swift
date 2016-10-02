//
//  MetricTime.swift
//  Metric Time
//
//  Created by ACE on 9/29/16.
//  Copyright © 2016 Adrian Edwards. All rights reserved.
//

import Foundation

class MetricTime {
    
    
    func drawAnalogClock() {
        /*
 
         let hourLayer = CAShapeLayer()
         let minuteLayer = CAShapeLayer()
         let secondLayer = CAShapeLayer()
         let centerPiece = CAShapeLayer()

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
         

 
 
 */
        
    }
    
    func updateHandsPosition() {
        /*
 
         func rotateHands(_ view : UIView, rotation:(hour:CGFloat,minute:CGFloat,second:CGFloat)){
         
         hourLayer.transform = CATransform3DMakeRotation(rotation.hour, 0, 0, 1)
         minuteLayer.transform = CATransform3DMakeRotation(rotation.minute, 0, 0, 1)
         secondLayer.transform = CATransform3DMakeRotation(rotation.second, 0, 0, 1)
         
         }
 */
        
    }
    
    func getCurrentMetricTime() {
        
        /*
         /*calculate metric "hours", "minutes", and "seconds" */
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

}
