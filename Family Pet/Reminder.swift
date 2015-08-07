//
//  Reminder.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/7/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

enum ReminderType: Int {
    case Feed = 0
    case Play = 1
    case Walk = 2
    case Vet = 3
    case Meds = 4
    
}

enum ReminderFrequency: Int {
    case Once = 0
    case Daily = 1
    case Weekly = 2
}

enum ReminderQueue: Int {
    case Daily = 0
    case Weekly = 1
}

class Reminder: PFObject, PFSubclassing {
    @NSManaged var user: PFUser
    @NSManaged var pet: Pet
    @NSManaged var type: ReminderType.RawValue
    @NSManaged var date: NSDate
    @NSManaged var frequency: ReminderFrequency.RawValue
    @NSManaged var queue: ReminderQueue.RawValue
    
    //1
    class func parseClassName() -> String {
        return "Reminder"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    init(user: PFUser, pet: Pet, type: ReminderType, date: NSDate, frequency: ReminderFrequency, queue: ReminderQueue) {
        super.init()
        self.user = user
        self.pet = pet
        self.type = type.rawValue
        self.date = date
        self.frequency = frequency.rawValue
        self.queue = queue.rawValue
    }
    
    func getIcon() -> UIImage {
        var icon: UIImage
        switch type {
            case ReminderType.Feed.rawValue:
                icon = UIImage(named: "feedIcon")!
            default:
                icon = UIImage(named: "feedIcon")!
        }
        return icon
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