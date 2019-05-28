//
//  paths.swift
//  Battle Void
//
//  Created by Ever Time Cole on 3/1/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import Foundation
import CoreGraphics

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 4294967296)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomInt(maxa: Int) -> Int {
    let n = Int(arc4random_uniform(UInt32(maxa)))
    return n
}


func pathOfForceField(scaler: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.addArc(center: CGPoint(x: 0,y: 0), radius: scaler, startAngle: 0, endAngle: 1, clockwise: true)
    path.addArc(center: CGPoint(x: 0,y: 0), radius: scaler, startAngle: 1, endAngle: 0, clockwise: true)
    path.closeSubpath()
    return path
}

func pathOfShip(scaler: Int) -> CGPath{
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -9*scaler, y: 6*scaler))
    path.addLine(to: CGPoint(x: -9*scaler, y: -4*scaler))
    path.addQuadCurve(to: CGPoint(x: -5*scaler, y: -10*scaler), control: CGPoint(x: -9*scaler, y: -9*scaler))
    path.addLine(to: CGPoint(x: 5*scaler, y: -10*scaler))
    path.addQuadCurve(to: CGPoint(x: 9*scaler, y: -4*scaler), control: CGPoint(x: 9*scaler, y: -9*scaler))
    path.addLine(to: CGPoint(x: 9*scaler, y: 6*scaler))
    path.addQuadCurve(to: CGPoint(x: 5*scaler, y: -4*scaler), control: CGPoint(x: 7*scaler, y: -9*scaler))
    path.addLine(to: CGPoint(x: 5*scaler, y: 4*scaler))
    path.addLine(to: CGPoint(x: 1*scaler, y: 6*scaler))
    path.addLine(to: CGPoint(x: 1*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: -1*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: -1*scaler, y: 6*scaler))
    path.addLine(to: CGPoint(x: -5*scaler, y: 4*scaler))
    path.addLine(to: CGPoint(x: -5*scaler, y: -4*scaler))
    path.addQuadCurve(to: CGPoint(x: -9*scaler, y: 6*scaler), control: CGPoint(x: -7*scaler, y: -9*scaler))
    path.closeSubpath()
    return path
}

func pathOfAsteroid(scaler: Int) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -1, y: 0))
    for v in [[-1,-1],[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0],] {
        let randX = v[0] * Int(random(min: CGFloat(scaler/10), max: CGFloat(scaler)))
        let randY = v[1] * Int(random(min: CGFloat(scaler/10), max: CGFloat(scaler)))
        path.addLine(to: CGPoint(x: randX, y: randY))
    }
    path.closeSubpath()
    return path
}

func pathOfForceFieldUpgrade(scaler: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.addArc(center: CGPoint(x: 0,y: 0), radius: 8*scaler, startAngle: 0, endAngle: 1, clockwise: true)
    path.addArc(center: CGPoint(x: 0,y: 0), radius: 8*scaler, startAngle: 1, endAngle: 0, clockwise: true)
    path.move(to: CGPoint(x: -10*scaler, y: -10*scaler))
    path.addLine(to: CGPoint(x: -10*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: 10*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: 10*scaler, y: -10*scaler))
    path.addLine(to: CGPoint(x: -10*scaler, y: -10*scaler))
    path.closeSubpath()
    return path
}

func pathOfMedPack(scaler: Int) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -10*scaler, y: -10*scaler))
    path.addLine(to: CGPoint(x: -10*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: 10*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: 10*scaler, y: -10*scaler))
    path.addLine(to: CGPoint(x: -10*scaler, y: -10*scaler))
    path.move(to: CGPoint(x: 0*scaler, y: -7*scaler))
    path.addLine(to: CGPoint(x: 0*scaler, y: 7*scaler))
    path.move(to: CGPoint(x: -7*scaler, y: 0*scaler))
    path.addLine(to: CGPoint(x: 7*scaler, y: 0*scaler))
    path.closeSubpath()
    return path
}

func pathOfMissileUpgrade(scaler: Int) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -10*scaler, y: -10*scaler))
    path.addLine(to: CGPoint(x: -10*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: 10*scaler, y: 10*scaler))
    path.addLine(to: CGPoint(x: 10*scaler, y: -10*scaler))
    path.addLine(to: CGPoint(x: -10*scaler, y: -10*scaler))
    path.move(to: CGPoint(x: 0*scaler, y: 7*scaler))
    path.addLine(to: CGPoint(x: 6*scaler, y: -7*scaler))
    path.addLine(to: CGPoint(x: 0*scaler, y: -2*scaler))
    path.addLine(to: CGPoint(x: -6*scaler, y: -7*scaler))
    path.addLine(to: CGPoint(x: 0*scaler, y: 7*scaler))
    path.closeSubpath()
    return path
}

func pathOfMissile(scaler: Int) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 0*scaler, y: 7*scaler))
    path.addLine(to: CGPoint(x: 6*scaler, y: -7*scaler))
    path.addLine(to: CGPoint(x: 0*scaler, y: -2*scaler))
    path.addLine(to: CGPoint(x: -6*scaler, y: -7*scaler))
    path.addLine(to: CGPoint(x: 0*scaler, y: 7*scaler))
    path.closeSubpath()
    return path
}

func pathOfTriY(yScale: CGFloat, xScale: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -1*xScale, y: 1*yScale))
    path.addLine(to: CGPoint(x: 1*xScale, y: 1*yScale))
    path.addLine(to: CGPoint(x: 0, y: 0))
    path.closeSubpath()
    return path
}

func pathOfTriX(yScale: CGFloat, xScale: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -1*xScale, y: -1*yScale))
    path.addLine(to: CGPoint(x: -1*xScale, y: 1*yScale))
    path.addLine(to: CGPoint(x: 0, y: 0))
    path.closeSubpath()
    return path
}

func pathOfSlider(scaler: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: scaler, y: scaler))
    path.addLine(to: CGPoint(x: 6*scaler, y: scaler))
    path.addArc(center: CGPoint(x: 6*scaler, y: scaler/2), radius: scaler/2, startAngle: 2 * .pi/4, endAngle: 6 * .pi/4, clockwise: true)
    path.addLine(to: CGPoint(x: scaler, y: 0))
    path.addArc(center: CGPoint(x: scaler/2, y: scaler/2), radius: scaler/2, startAngle: 6 * .pi/4, endAngle: 2 * .pi/4, clockwise: true)
    path.closeSubpath()
    return path
}

func pathOfButton(rect: CGRect) -> CGPath {
    let totW = rect.width/4
    let totH = rect.height/4
    let innerRect = CGRect(x: rect.minX+totW/2, y: rect.minY+totH/2, width: rect.width-totW, height: rect.height-totH)
    let outerRect = rect//CGRect(x: rect.minX-totW, y: rect.minY-totH, width: rect.width+totW, height: rect.height+totH)
    var firstPoint = CGPoint()
    let path = CGMutablePath()
    for side in 1...4 {
        let amnt = Int(random(min: 4, max: 8))
        if side == 1 {
            firstPoint = CGPoint(x: random(min: innerRect.maxX, max: outerRect.maxX), y: innerRect.maxY)
            path.move(to: firstPoint)
            let chunkSize = innerRect.height/CGFloat(amnt)
            for chunk in 1...amnt {
                let randR = random(min: innerRect.maxX, max: outerRect.maxX)
                path.addLine(to: CGPoint(x: randR, y: innerRect.maxY-CGFloat(chunk)*chunkSize))
            }
        }
        if side == 2 {
            let chunkSize = innerRect.width/CGFloat(amnt)
            for chunk in 1...amnt {
                let randB = random(min: outerRect.minY, max: innerRect.minY)
                path.addLine(to: CGPoint(x: innerRect.maxX-CGFloat(chunk)*chunkSize, y: randB))
            }
        }
        if side == 3 {
            let chunkSize = innerRect.height/CGFloat(amnt)
            for chunk in 1...amnt {
                let randL = random(min: outerRect.minX, max: innerRect.minX)
                path.addLine(to: CGPoint(x: randL, y: innerRect.minY+CGFloat(chunk)*chunkSize))
            }
        }
        if side == 4 {
            let chunkSize = innerRect.width/CGFloat(amnt)
            for chunk in 1...amnt {
                let randT = random(min: innerRect.maxY, max: outerRect.maxY)
                path.addLine(to: CGPoint(x: innerRect.minX+CGFloat(chunk)*chunkSize, y: randT))
            }
            path.addLine(to: firstPoint)
        }
    }

    path.closeSubpath()
    return path
}

func pathOfCircleChunkGivenChord(r: CGFloat, d: CGFloat, scaler: CGFloat) -> CGPath {
    let path = CGMutablePath()
    let ang = 2 * asin(d/(2*r))
    path.addArc(center: CGPoint(x: 0, y: 0), radius: r*scaler, startAngle: ang, endAngle: 0, clockwise: true)
    return path
}
func pathOfCircleChunkGivenAngle(ang: CGFloat, radius: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.addArc(center: CGPoint(x: 0, y: 0), radius: radius, startAngle: ang, endAngle: 0, clockwise: true)
    return path
}

func pathOfRect(rect: CGRect) -> CGPath {
    let path = CGMutablePath()
    path.addRect(rect)
    return path
}


func findFrame(tag: Int) -> CGRect {
    if tag == 1 {
        return CGRect(x: -590, y: -300, width: 10, height: 600)
    } else if tag == 2 {
        return CGRect(x: 590, y: -300, width: 10, height: 600)
    } else if tag == 3 {
        return CGRect(x: -550, y: 315, width: 1100, height: 10)
    } else if tag == 4 {
        return CGRect(x: -550, y: -315, width: 1100, height: 10)
    } else {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
}
