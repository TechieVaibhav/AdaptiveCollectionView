//
//  CollectionViewCell.swift
//  ContactPad
//
//  Created by Vaibhav Sharma on 03/09/19.
//  Copyright © 2019 Vaibhav Sharma. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblTitle.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 20) : .systemFont(ofSize: 28)
        
        lblTitle.textAlignment = .center
        lblDetails.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .boldSystemFont(ofSize: 8) : .boldSystemFont(ofSize: 10)
        lblDetails.textAlignment = .center
    }
    func updateData(contentModel: ContentModel) {
        self.lblTitle.text = contentModel.title
        self.lblDetails.text = contentModel.description
        if let imageName = contentModel.imageName, !imageName.isEmpty {
            self.image.image = UIImage(named: imageName)
        }
        if let isBgVisible = contentModel.isContentVisible, isBgVisible {
            self.cellContentView.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        } else {
            self.cellContentView.backgroundColor = UIColor.clear
        }
        self.lblDetails.text = contentModel.description
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width/2
    }
}
