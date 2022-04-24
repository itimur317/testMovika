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
        let path = UIBezierPath()
        
        let transformer = TransformSVG()
        let paths = transformer.transform(name: "1_1")
        for curPath in paths {
            switch curPath.0 {
            case "M":
                path.move(to: curPath.1[0])
            case "L":
                path.addLine(to: curPath.1[0])
            case "C":
                path.addCurve(to: curPath.1[2], controlPoint1: curPath.1[0], controlPoint2: curPath.1[1])
            default:
                print("smth wrong on curve")
            }
        }
//        path.close()
        
        UIColor.blue
        path.lineWidth = 2
        path.stroke()
    }
}
