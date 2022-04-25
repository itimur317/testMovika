//
//  TransformSVG.swift
//  testMovika
//
//  Created by Timur on 24.04.2022.
//

import Foundation
import UIKit


protocol TransformSVGProtocol: AnyObject {
    func transform(name: String) -> [(String, [CGPoint])]
}

final class TransformSVG: TransformSVGProtocol {
    
    // func to convert SVG to String
    private func SVGToString(name: String) ->  String? {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "svg")!)
        do {
            let data = try Data(contentsOf: url)
            let str = String(decoding: data, as: UTF8.self)
            return str
        } catch {
            return nil
        }
    }
    
    
    private func isLetter(char: Character) -> Bool {
        if (char == "M" || char == "L" ||
            char == "H" || char == "V" ||
            char == "Z" || char == "C") {
            return true
        }
        return false
    }
    
    
    private func convertML(from str: String) -> CGPoint {
        var point = str.split(separator: ",")
        if str[str.startIndex] == " " {
            point[0].remove(at: point[0].startIndex)
        }
        let index = point[1].index(point[1].endIndex, offsetBy: -1)
        if point[1][index] == " " {
            point[1].remove(at: index)
        }
        point[0].remove(at: point[0].startIndex)
        var coordinates: [Double] = []
        for dim in point {
            if let coord = Double(dim) {
                coordinates += [coord]
            }
        }
        
        return CGPoint(x: coordinates[0], y: coordinates[1])
    }
    
    private func convertC(from str: String) -> [CGPoint] {
        
        var threePoints = str.split(separator: " ")
        threePoints[0].remove(at: threePoints[0].startIndex)
        var sixCoordinates: [Double] = []
        
        for point in threePoints {
            let coordinates = point.split(separator: ",")
            for coordinate in coordinates {
                if let coord = Double(coordinate) {
                    sixCoordinates += [coord]
                }
            }
        }
        
        var points: [CGPoint] = []
        
        for i in 0...5 where i % 2 == 0 {
            points.append(CGPoint(x: sixCoordinates[i], y: sixCoordinates[i + 1]))
        }
        return points
    }
    
    
    // convert string to path
    private func converterStringToPath(from str: String) -> [(String, [CGPoint])] {
        var partsOfPath: [(String, [CGPoint])] = []
        var pathsString: [String] = []
        var currentString = ""
        for i in 0..<str.count {
            let curIndex = str.index(str.startIndex, offsetBy: i)
            
            if self.isLetter(char: str[curIndex]) {
                if curIndex != str.startIndex {
                    pathsString += [currentString]
                }
                currentString = ""
            }
            currentString.append(str[curIndex])
        }
        pathsString += [currentString]
        
        for str in pathsString {
            switch str[str.startIndex] {
            case "M":
                let point = self.convertML(from: str)
                print(point)
                partsOfPath += [("M", [point])]
            case "L":
                let point = self.convertML(from: str)
                partsOfPath += [("L", [point])]
            case "C":
                let points = self.convertC(from: str)
                print(points)
                partsOfPath += [("C", points)]
            default:
                print("smth wrong")
            }
        }
        
        return partsOfPath
        
    }
    
    
    // func to highlight information about curve
    private func highlightSubstring(from svg: String, word: String) -> String {
        var pathInString = ""
        //      find "<path d=" in StringSVG
        for i in 0..<svg.count {
            let startIndex = svg.index(svg.startIndex, offsetBy: i)
            if svg[startIndex] == word[word.startIndex] {
                let curIndex = svg.index(startIndex, offsetBy: word.count)
                if svg[startIndex..<curIndex] == word {
                    var endIndex = curIndex
                    var k = 0
                    // to highlight Substring in String of SVG
                    while svg[svg.index(curIndex, offsetBy: k)] != "\"" {
                        endIndex = svg.index(curIndex, offsetBy: k)
                        pathInString += [svg[endIndex]]
                        k += 1
                    }
                    print(pathInString)
                    break
                }
            }
        }
        return pathInString
    }
    
    
    private func converterStringToPolyline(from str: String) -> [(String, [CGPoint])] {
        var coordinates = str.split(separator: " ")
        var partsOfPath: [(String, [CGPoint])] = []
        var coords: [Double] = []
        for coordinate in coordinates {
            if let coord = Double(coordinate) {
                coords.append(coord)
            }
        }
        for i in 0..<coords.count where i % 2 == 0 {
            if i == 0 {
                partsOfPath.append(("M", [CGPoint(x: coords[i], y: coords[i + 1])]))
            } else {
                partsOfPath.append(("L", [CGPoint(x: coords[i], y: coords[i + 1])]))
            }
        }
        return partsOfPath
    }
    
    
    func transform(name: String) -> [(String, [CGPoint])] {
        guard let svg = self.SVGToString(name: name) else {
            return [("", [CGPoint(x: 0, y: 0)])]
        }
        // cut to convert
//        print(svg)
        if svg.contains("<path d=\"") {
//            print(self.highlightSubstringPath(from: svg))
            let highlighted = self.highlightSubstring(from: svg, word: "<path d=\"")
            return self.converterStringToPath(from: highlighted)
        } else {
            let highlighted = self.highlightSubstring(from: svg, word: "points=\"")
//            print(self.converterStringToPolyline(from: highlighted))
            return self.converterStringToPolyline(from: highlighted)
        }
        
    }
}
