//
//  Note+CoreDataClass.swift
//  Notes_Sample
//
//  Created by Ashwini on 04/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.id = UUID()
    }
    
    convenience init(title:String, detail:String, creationDate:Date, moc: NSManagedObjectContext, images:[Data]?) {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: moc)
        self.init(entity: entity!, insertInto: moc)
        self.title = title
        self.noteDetail = detail
        self.creationDate = creationDate
        self.images = images
    }

}
