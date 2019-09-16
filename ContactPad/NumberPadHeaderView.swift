//
//  NumberPadHeaderView.swift
//  ContactPad
//
//  Created by Vaibhav Sharma on 05/09/19.
//  Copyright © 2019 Vaibhav Sharma. All rights reserved.
//

import UIKit

class NumberPadHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //Update Header Value
    func updateHeaderValue(value: String) {
        lblNumber.text = value
    }
}
