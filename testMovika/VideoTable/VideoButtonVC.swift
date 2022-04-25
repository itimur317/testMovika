//
//  ViewController.swift
//  testMovika
//
//  Created by Timur on 23.04.2022.
//

import UIKit
import AVKit
import AVFoundation

protocol VideoButtonVCProtocol: AnyObject {
    func openVideo()
}

final class VideoButtonVC: UIViewController {
    
    var presenter: VideoButtonPresenterProtocol
    var pathShape = UIBezierPath()
    
    init(presenter: VideoButtonPresenterProtocol){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let curveView = CurveView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentInformation.shared.videoNumber = 1
        
        var videoButton = UIButton()
        navigationController?.topViewController?.title = "Videos"
        view.backgroundColor = .white
        
        curveView.isHidden = true
        curveView.translatesAutoresizingMaskIntoConstraints = false
        curveView.backgroundColor = UIColor.blue.withAlphaComponent(0)
        view.addSubview(curveView)
        
        curveView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        curveView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        curveView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        curveView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        if UIDevice.current.orientation.isLandscape {
            videoButton = UIButton(frame: CGRect(x: view.bounds.height / 2 - 50,
                                                 y: view.bounds.height / 2 - 50,
                                                 width: 100,
                                                 height: 100))
        }
        else {
            videoButton = UIButton(frame: CGRect(x: view.bounds.width / 2 - 50,
                                                 y: view.bounds.width / 2 - 50,
                                                 width: 100,
                                                 height: 100))
        }
        videoButton.layer.masksToBounds = true
        videoButton.layer.cornerRadius = 9
        videoButton.setImage(UIImage(named: "videoButtonImage"), for: .normal)
        videoButton.contentVerticalAlignment = .fill
        videoButton.contentHorizontalAlignment = .fill
        videoButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        videoButton.backgroundColor = UIColor(red: 0.40, green: 0.29, blue: 0.87, alpha: 1.00)
        videoButton.addTarget(self, action: #selector(didTapVideoButton(_:)), for: .touchUpInside)
        view.addSubview(videoButton)
        
    }
    
    @objc
    private func didTapVideoButton(_ sender: UIButton) {
        
        // UIDevice.current.orientation.isLandscape работал с проблемами при загрузке
        // (частая проблема на форумах)
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            self.presenter.didTapVideoButton()
        } else {
            let alert = UIAlertController(title: "Поверните телефон", message: "Поверните телефон в горизонтальный режим", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    
}

extension VideoButtonVC: VideoButtonVCProtocol {
    func openVideo() {
        let player = AVPlayer(url: self.presenter.videosURL[0])
        let layer = AVPlayerLayer(player: player)
        
        layer.frame = CGRect(x: 0, y: 0, width: view.bounds.height, height: view.bounds.width)
        layer.frame = view.frame
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        
        navigationController?.topViewController?.title = ""
        player.play()
        CurrentInformation.shared.paused = false
        
        let asset = AVAsset(url: self.presenter.videosURL[0])
        let duration = asset.duration.seconds
        let randomTime = Double.random(in: 0..<duration)
        player.perform(#selector(player.pause), with: nil, afterDelay: randomTime)
        CurrentInformation.shared.paused = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) {
            self.curveView.isHidden = false
            self.view.addSubview(self.curveView)
        }
    }
}
