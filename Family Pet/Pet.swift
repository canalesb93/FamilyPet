//
//  WallPost.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/8/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import Foundation
import Parse

enum PetType: Int {
    case Dog = 0
    case Cat = 1
    case Other = 2
    
}

class Pet: PFObject, PFSubclassing {
    @NSManaged var image: PFFile?
    @NSManaged var user: PFUser
    @NSManaged var name: String
    @NSManaged var type: PetType.RawValue
    @NSManaged var attributes: String?
    
    //1
    class func parseClassName() -> String {
        return "Pet"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(image: PFFile?, user: PFUser, name: String, type: PetType, attributes: String?) {
        super.init()
        self.image = image
        self.user = user
        self.name = name
        self.type = type.rawValue
        self.attributes = attributes
    }
    
    override init() {
        super.init()
    }

//    class func ownersQuery() -> PFQuery? {
//        //1
//        let query = PFQuery(className: Pet.parseClassName())
//        //2
//        query.includeKey("user")
//        //3
//        query.orderByDescending("createdAt")
//        return query
//    }

}