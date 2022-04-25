//
//  CurveView.swift
//  testMovika
//
//  Created by Timur on 24.04.2022.
//

import Foundation
import UIKit


final class CurveView: UIView {
    override func draw(_ rect: CGRect) {
        // draw line from SVG file
        let path = UIBezierPath()
        var startPoint = CGPoint(x: 0, y: 0)
        path.move(to: CGPoint(x: 0, y: 0))
        
        let transformer = TransformSVG()
        let paths = transformer.transform(name: "1_\(CurrentInformation.shared.curveNumber)")
        
        var pathPoints: [CGPoint] = []
        
        for curPath in paths {
            switch curPath.0 {
            case "M":
                path.move(to: curPath.1[0])
                if startPoint == CGPoint(x: 0, y: 0) {
                    startPoint = curPath.1[0]
                }
            case "L":
                let startPoint = path.currentPoint
                let endPoint = curPath.1[0]
                path.addLine(to: curPath.1[0])
                
                // calculate points of line
                let deltaX = endPoint.x - startPoint.x
                let deltaY = endPoint.y - startPoint.y
                for t1 in 0...200 {
                    let tau = Int(t1)
                    let t: Double = Double(tau) * 0.005
                    pathPoints.append(CGPoint(x: startPoint.x + CGFloat(t) * deltaX,
                                              y: startPoint.y + CGFloat(t) * deltaY))
                }
            case "C":
                let startPoint = path.currentPoint
                let endPoint = curPath.1[2]
                let controlPoint1 = curPath.1[0]
                let controlPoint2 = curPath.1[1]
                
                
                path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                
                // calculate points of Bezier's curve
                for t1 in 0...200 {
                    let tau = Int(t1)
                    let delta: Double = 1 - Double(tau) / 200
                    let t: Double = Double(tau) * 0.005
                    
                    let firstPartX = startPoint.x * delta * delta * delta
                    let secondPartX = controlPoint1.x * 3 * t * delta * delta
                    let thirdPartX = controlPoint2.x * 3 * t * t * delta
                    let fourthPartX = endPoint.x * t * t * t
                    let x = (firstPartX + secondPartX + thirdPartX + fourthPartX)
                    
                    let firstPartY = startPoint.y * delta * delta * delta
                    let secondPartY = controlPoint1.y * 3 * t * delta * delta
                    let thirdPartY = controlPoint2.y * 3 * t * t * delta
                    let fourthPartY = endPoint.y * t * t * t
                    let y = (firstPartY + secondPartY + thirdPartY + fourthPartY)
                    
                    pathPoints.append(CGPoint(x: x, y: y))
                }
            default:
                print("smth wrong on curve")
            }
        }
        amountOfPoints = pathPoints.count
        redLine = pathPoints
        
        UIColor.white.set()
        path.lineWidth = 2
        path.stroke()
        
        
        // draw line by finger
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineWidth(2)
        context.setStrokeColor(.init(red: 0, green: 0, blue: 0, alpha: 1))
        
        for (i, p) in line.enumerated() {
            if i == 0 {
                context.move(to: p)
            } else {
                context.addLine(to: p)
            }
        }
        
        context.strokePath()
        
        // redLine on white
        guard let contextRed = UIGraphicsGetCurrentContext() else { return }
        contextRed.setLineWidth(4)
        contextRed.setStrokeColor(.init(red: 0.72, green: 0, blue: 0, alpha: 1))
        for (i, p) in redLine.enumerated() where i < iterator {
            if i == 0 {
                contextRed.move(to: p)
            } else {
                contextRed.addLine(to: p)
            }
        }
        
        contextRed.strokePath()
    }
    
    var amountOfPoints: Int = 0
    var iterator: Int = 0
    var line: [CGPoint] = []
    var redLine: [CGPoint] = []
    var sumForMetric: Double = 0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else {
            return
        }
        
        if iterator != amountOfPoints {
            let deltaX = point.x - redLine[iterator].x
            let deltaY = point.y - redLine[iterator].y
            if deltaX * deltaX + deltaY * deltaY < 400 {
                sumForMetric += sqrt(deltaX * deltaX + deltaY * deltaY)
                iterator += 1
            }
        } else {
            print("\n\n\n\n")
            print("*Переход на следующее видео/отжатие паузы*")
            print("Не успел добавить:С")
            print("Используется метод наим квадратов")
            print("Высчитывается среднее от квадратов расстояний")
            print("Чем меньше сумма квадратов расстояний, деленная на кол-во точек, тем лучше точность")
            print("Точность нарисованной кривой: \(sumForMetric / Double(amountOfPoints))")
        }
        
        line.append(point)
        setNeedsDisplay()
    }
}



