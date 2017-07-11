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
    
    var ref:DatabaseReference?
    var key:String
    
    init(user:String, imageURL:String, matches:String, correctMatch:Bool, key:String = "") {
        self.user = user
        self.imageURL = imageURL
        self.matches = matches
        self.correctMatch = correctMatch
        self.key = key
        self.ref = nil
        
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? [String: AnyObject]
        user = snapshotValue?["user"] as? String
        imageURL = snapshotValue?["imageURL"] as? String
        matches = snapshotValue?["matches"] as? String
        correctMatch = snapshotValue?["correctMatch"] as! Bool
        key = snapshot.key
        ref = snapshot.ref
        
    }
    
    func toAnyObject() -> Any {
        return ["user":user ?? "", "imageURL":imageURL ?? "", "matches":matches ?? "", "correctMatch":correctMatch]
    }
    
    
}
