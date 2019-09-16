//
//  ContentModel.swift
//  ContactPad
//
//  Created by Vaibhav Sharma on 06/09/19.
//  Copyright © 2019 Vaibhav Sharma. All rights reserved.
//

import Foundation

class ContentModel {
    var title : String?
    var description : String?
    var isContentVisible : Bool?
    var imageName : String?
    var actionType : String?
    init( title : String?,description : String?,isContentVisible : Bool?,imageName : String?, actionType: String?) {
        self.title  = title
        self.description  = description
        self.isContentVisible = isContentVisible
        self.imageName = imageName
        self.actionType = actionType
    }
}
