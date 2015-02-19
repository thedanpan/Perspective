//
//  Timeline.swift
//  Perspective
//
//  Created by Apprentice on 2/18/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class Timeline : NSObject {
    var theme: String
//    var videos: NSArray
    var perspectiveId: String
    init(theme: String, perspectiveId: String) {
        self.theme = theme
        self.perspectiveId = perspectiveId
    }
}
