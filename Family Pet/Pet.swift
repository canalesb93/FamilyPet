//
//  WallPost.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/8/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import Foundation
import Parse

class Pet: PFObject, PFSubclassing {
    @NSManaged var image: PFFile?
    @NSManaged var user: PFUser
    @NSManaged var petName: String
    @NSManaged var petDescription: String?
    
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
    
    init(image: PFFile?, user: PFUser, petName: String, petDescription: String?) {
        super.init()
        
        self.image = image
        self.user = user
        self.petName = petName
        self.petDescription = petDescription
    }
    
    override init() {
        super.init()
    }
    
    override class func query() -> PFQuery? {
        //1
        let query = PFQuery(className: Pet.parseClassName())
        //2
        query.includeKey("user")
        //3
        query.orderByDescending("createdAt")
        return query
    }
    
}