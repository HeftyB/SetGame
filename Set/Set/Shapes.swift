//
//  Diamond.swift
//  Set
//
//  Created by Andrew Shields on 9/5/22.
//

import SwiftUI

struct Diamond: CardShape {
    var striped = false
    
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.minX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        
        let slope: CGFloat = (rect.minY - rect.midY) / rect.midX - rect.minX
        let interval: CGFloat = rect.width / 4
        
        var p = Path()
        
        p.move(to: start)
        p.addLines([start, top, right, bottom, start])

        if striped {
            var p1 = start
            var p2 = start
            p.move(to: start)
            
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
}

struct CardCapsule: CardShape {
    var striped = false
    
    func path(in rect: CGRect) -> Path {
        let xMargin = rect.width * 0.25
        let yMargin = rect.height * 0.1
        var p = Path()
        let p1 = CGPoint(x: rect.minX + xMargin, y: rect.minY + yMargin)
        let p2 = CGPoint(x: rect.maxX - xMargin, y: rect.minY + yMargin)
        let p3 = CGPoint(x: rect.maxX - xMargin, y: rect.maxY - yMargin)
        let p4 = CGPoint(x: rect.minX + xMargin, y: rect.maxY - yMargin)
        let rad = (p2.y - p3.y) / 2
        let height = p1.y - p4.y
        let interval = (p2.x - p1.x) / 3
        
        p.move(to: p1)
        p.addLine(to: p2)
        p.addArc(center: CGPoint(x: p3.x, y: p2.y - rad), radius: CGFloat(rad), startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 270), clockwise: false)
        p.addLine(to: p4)
        p.addArc(center: CGPoint(x: p4.x, y: p4.y + CGFloat(rad)), radius: CGFloat(rad), startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 90), clockwise: false)
        
        if striped {
            while p.currentPoint!.x < p2.x + 1 {
                p.addLine(to: CGPoint(x: p.currentPoint!.x, y: p.currentPoint!.y - height))
                p.move(to: CGPoint(x: p.currentPoint!.x + interval, y: p.currentPoint!.y + height))
            }
        }
        return p
    }
}

struct Squiggle: CardShape {
    var striped = false
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let leftMid = CGPoint(x: rect.minX, y: rect.midY)
        let rightMid = CGPoint(x: rect.maxX, y: rect.midY)
        let end1 = CGPoint(x: rect.midX, y: rect.midY * 0.80)
        let end2 = CGPoint(x: rect.midX, y: rect.midY * 1.2)
        
        let control1 = CGPoint(x: rect.midX / 8, y: rect.midY / 3)
        let control2 = CGPoint(x: rect.maxX * 0.95, y: rect.maxY * 0.70)
        let control3 = CGPoint(x: rect.maxX - (rect.midX / 8), y: rect.maxY - (rect.midY / 3))
        let control4 = CGPoint(x: rect.maxX * 0.05, y: rect.maxY * 0.30)
        
        p.move(to: leftMid)
        /// upper left
        p.addQuadCurve(to: end1, control: control1)
        /// upper right
        p.addQuadCurve(to: rightMid, control: control2)
        /// lower right
        p.addQuadCurve(to: end2, control: control3)
        /// lower left
        p.addQuadCurve(to: leftMid, control: control4)
        
        if striped {
            for i in 1...10 {
                /// left side start point / end point
                let p1 = quadraticBezier(parameter: intD(i), point1: leftMid, point2: control1, point3: end1)
                let p2 = quadraticBezier(parameter: intD(i), point1: leftMid, point2: control4, point3: end2)
                /// right side start / end point
                let p3 = quadraticBezier(parameter: intD(i), point1: end1, point2: control2, point3: rightMid)
                let p4 = quadraticBezier(parameter: intD(i), point1: end2, point2: control3, point3: rightMid)
                
                p.move(to: p1)
                p.addLine(to: p2)
                
                p.move(to: p3)
                p.addLine(to: p4)
            }
        }
        
        return p
    }
}


protocol CardShape: Shape {
    var striped: Bool { get set }
}

/// Finds Y-intercept  of a linear system using slope & coordinate point
/// y - b = m( x - a) where ( y, b ) = coordinates on line, (m) = slope
/// - Parameters:
///   - startingPoint: point to calculate y-intercept from
///   - x: 0 on the x-axis
///   - slope: slope of the linear system
/// - Returns: CGFloat of y-intercept
func pointSlope(startingPoint: CGPoint, x:CGFloat, slope: CGFloat) -> CGFloat {
    (slope * x) - (slope * startingPoint.x) + startingPoint.y
}

/// finds y value for a linear system's x value given it's slope and y-intercept
/// y = mx + b where (m) = slope, (y) = y-intercept
/// - Parameters:
///   - x: x value of new coordinate
///   - slope: slope of linear system
///   - yInt: pont where line intersects with y-axis
/// - Returns: CGPont(x: x, y: result)
func slopeIntercept(x: CGFloat, slope: CGFloat, yInt: CGFloat) -> CGPoint {
    CGPoint(x: x, y: (slope * x) + yInt)
}

/// finds coordinate along a quadratic bezier curve given a starting pont, ending pont. and control point
/// - Parameters:
///   - t: parameter along given curve
///   - p1: curve starting point
///   - p2: control point of the curve
///   - p3: curve ending point
/// - Returns: CGPoint
func quadraticBezier(parameter t: Double, point1 p1: CGPoint, point2 p2: CGPoint, point3 p3: CGPoint) -> CGPoint {
    let x: CGFloat = squared(1 - t) * p1.x + (2 * (1 - t)) * t * p2.x + squared(t) * p3.x
    let y: CGFloat = squared(1 - t) * p1.y + (2 * (1 - t)) * t * p2.y + squared(t) * p3.y
    
    return CGPoint(x: x, y: y)
}

/// square a value
/// - Parameter x: value to be squared
/// - Returns: x ** 2
func squared(_ x: Double) -> Double { x * x }

/// moves value from whole int to value in tenths
/// - Parameter x: value to convert
/// - Returns: x = 1 -->  0.1
func intD(_ x: Int) -> Double { Double(x) * 0.10 }
