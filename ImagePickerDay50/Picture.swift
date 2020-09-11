//
//  Picture.swift
//  ImagePickerDay50
//
//  Created by Samat on 01.08.2020.
//  Copyright © 2020 somfish. All rights reserved.
//

import Foundation

class Picture: NSObject, Codable {
    var imageName: String
    var caption: String
    
    init(imageName: String, caption: String) {
        self.imageName = imageName
        self.caption = caption
    }
}
