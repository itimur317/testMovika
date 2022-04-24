//
//  VideoCell.swift
//  testMovika
//
//  Created by Timur on 23.04.2022.
//

import Foundation
import UIKit

class VideoCell: UITableViewCell {
    let videoNumber = UILabel()
    
    func configure(with number: Int) {
        videoNumber.text = String(number)
        videoNumber.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
        videoNumber.backgroundColor = UIColor(red: 0.40, green: 0.29, blue: 0.87, alpha: 1.00)
        videoNumber.layer.masksToBounds = true
        videoNumber.layer.cornerRadius = 10
        contentView.addSubview(videoNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 100)
        videoNumber.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 10)
    }
}
