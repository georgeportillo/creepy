//
//  Part.swift
//  swiftme
//
//  Created by George Portillo on 3/8/16.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation

class Part {
    var title: String?
    var views: Float?
    var image: String?
    var sentences: [String] = []
    var imageData: NSData?
    
    init(json: NSDictionary) {
        self.title = json["title"] as? String
        self.image = json["image"] as? String
        self.views = json["views"] as? Float
        self.sentences = (json["sentences"] as? Array)!
    }
}