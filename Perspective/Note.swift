//
//  Note.swift
//  Perspective
//
//  Created by Apprentice on 2/18/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class Note : NSObject {
    var fromUser: String
    var toUser: String
    var notificationType: String
    var perspectiveId: String?
    
    init(fromUser: String, toUser: String, notificationType: String) {
        self.fromUser = fromUser
        self.toUser = toUser
        self.notificationType = notificationType
    }
}