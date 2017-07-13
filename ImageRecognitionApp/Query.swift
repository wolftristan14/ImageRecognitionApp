//
//  Query.swift
//  ImageRecognitionApp
//
//  Created by Tristan Wolf on 2017-07-10.
//  Copyright © 2017 Tristan Wolf. All rights reserved.
//

import Foundation
import Firebase

struct Query {
    
    var user:String?
    var imageURL:String?
    var matches:String?
    var correctMatch:Bool
    
    init(user:String, imageURL:String, matches:String, correctMatch:Bool) {
        self.user = user
        self.imageURL = imageURL
        self.matches = matches
        self.correctMatch = correctMatch
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? [String: AnyObject]
        user = snapshotValue?["user"] as? String
        imageURL = snapshotValue?["imageURL"] as? String
        matches = snapshotValue?["matches"] as? String
        correctMatch = snapshotValue?["correctMatch"] as! Bool
  
    }
    
    func toAnyObject() -> Any {
        return ["user":user ?? "", "imageURL":imageURL ?? "", "matches":matches ?? "", "correctMatch":correctMatch]
    }
    
    
}
