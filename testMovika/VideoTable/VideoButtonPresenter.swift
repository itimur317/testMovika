//
//  VideoButtonPresenter.swift
//  testMovika
//
//  Created by Timur on 23.04.2022.
//

import Foundation

protocol VideoButtonPresenterProtocol: AnyObject {
    var videosURL: [URL] { get }
    func didTapVideoButton()
    
}

final class VideoButtonPresenter: VideoButtonPresenterProtocol {
    
    weak var viewController: VideoButtonVCProtocol?
    
    var videosURL: [URL] = VideoGetter.shared.videosURL
    
    func didTapVideoButton() {
        self.viewController?.openVideo()
    }
    
}
