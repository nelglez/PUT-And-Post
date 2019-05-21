//
//  Task.swift
//  PutAndPost
//
//  Created by Spencer Curtis on 5/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Task: Codable {
    
    let title: String
    let identifier: String
    
    init(title: String, identifier: String = UUID().uuidString) {
        self.title = title
        self.identifier = identifier
    }
    
}
