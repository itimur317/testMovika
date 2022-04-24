//
//  VideoTablePresenter.swift
//  testMovika
//
//  Created by Timur on 23.04.2022.
//

import Foundation

protocol VideoTablePresenterProtocol: AnyObject {
    var videosURL: [URL] { get }
    func didTapVideoButton()
    
}

final class VideoTablePresenter: VideoTablePresenterProtocol {

    weak var viewController: VideoTableVCProtocol?
    
    var videosURL: [URL] = VideoGetter.shared.videosURL
    
    func didTapVideoButton() {
        self.viewController?.openVideo()
    }

    
}
