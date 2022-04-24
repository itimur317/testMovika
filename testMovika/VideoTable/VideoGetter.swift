//
//  VideoCollectionModel.swift
//  testMovika
//
//  Created by Timur on 23.04.2022.
//

import Foundation

protocol VideoGetterProtocol: AnyObject {
    var videosURL: [URL] { get }
}

// Был реализован при помощи паттерна SingleTon геттер видео
// В зависимости от задачи, этот геттер можно будет легко заменить, например, при изменении источника видео 
final class VideoGetter: VideoGetterProtocol {
    static var shared: VideoGetterProtocol = VideoGetter()
    var videosURL: [URL] {
        get {
            var videosURL: [URL] = []
            
            for i in 1...2 {
                videosURL += [URL(fileURLWithPath: Bundle.main.path(forResource: "cat" + String(i), ofType: "MP4")!)]
            }
            print("returned")
            return videosURL
 
        }
    }
}


