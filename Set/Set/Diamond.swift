//
//  Diamond.swift
//  Set
//
//  Created by Andrew Shields on 9/5/22.
//

import SwiftUI

struct Diamond: Shape {
    let striped: Bool
    
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.minX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.height/3)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY - rect.height/3)
        
        let slope: CGFloat = ((rect.height/3) - rect.midY) / rect.midX - rect.minY
        let width = min(rect.width, rect.height)
        let interval: CGFloat = width / 10
        
        var p = Path()
        
        p.move(to: start)
        p.addLines([start, top, right, bottom, start])
    
        func y1(_ index: CGFloat) -> CGFloat { (slope * (p.currentPoint!.x + (interval * index))) - (slope * p.currentPoint!.x) + p.currentPoint!.y }
        func y2(_ index: CGFloat) -> CGFloat { ((slope * -1 ) * (p.currentPoint!.x + interval * index)) - ((slope * -1) * p.currentPoint!.x) + p.currentPoint!.y }
        
        if striped {
            var p1 = start
            var p2 = start
            
            while p1.x < top.x {
                p1 = slopeIntercept(x: p1.x + interval, slope: slope, yInt: rect.midY)
                p2 = slopeIntercept(x: p2.x + interval, slope: slope * -1, yInt: rect.midY)
                
                p.move(to: p1)
                p.addLine(to: p2)
            }
            
            while p1.x < right.x {
                p1 = slopeIntercept(x: p1.x + interval, slope: slope * -1, yInt: pointSlope(startingPoint: p1, x: rect.minX, slope: slope * -1))
                
                p2 = slopeIntercept(x: p2.x + interval, slope: slope, yInt: pointSlope(startingPoint: p2, x: rect.minX, slope: slope))
                
                p.move(to: p1)
                p.addLine(to: p2)
            }
        }
        
        return p
    }
    
    
    func slope(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        p2.y - p1.y / p2.x - p1.x
    }
    
    func pointSlope(startingPoint: CGPoint, x:CGFloat, slope: CGFloat) -> CGFloat {
        (slope * x) - (slope * startingPoint.x) + startingPoint.y
    }
    
    func slopeIntercept(x: CGFloat, slope: CGFloat, yInt: CGFloat) -> CGPoint {
        CGPoint(x: x, y: (slope * x) + yInt)
    }
}



struct CardCapsule: Shape {
    var striped: Bool
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let p1 = CGPoint(x: rect.minX, y: rect.minY)
        let p2 = CGPoint(x: rect.maxX, y: rect.minY)
        let p3 = CGPoint(x: rect.maxX, y: rect.maxY)
        let p4 = CGPoint(x: rect.minX, y: rect.maxY)
        let rad = (p2.y - p3.y) / 2
        let height = p1.y - p4.y
        let interval = (p2.x - p1.x) / 10
        
        p.move(to: p1)
        p.addLine(to: p2)
        p.addArc(center: CGPoint(x: p3.x, y: p2.y - rad), radius: CGFloat(rad), startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 270), clockwise: false)
        p.addLine(to: p4)
        p.addArc(center: CGPoint(x: p4.x, y: p4.y + CGFloat(rad)), radius: CGFloat(rad), startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 90), clockwise: false)
        
        if striped {
            for _ in 1...11 {
                p.addLine(to: CGPoint(x: p.currentPoint!.x, y: p.currentPoint!.y - height))
                p.move(to: CGPoint(x: p.currentPoint!.x + interval, y: p.currentPoint!.y + height))
            }
        }
        return p
    }
}




struct Squiggle: Shape {
    var striped: Bool
    
    func path(in rect: CGRect) -> Path {
        <#code#>
    }
}
