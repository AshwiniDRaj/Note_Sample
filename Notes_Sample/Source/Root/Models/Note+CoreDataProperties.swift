//
//  Note+CoreDataProperties.swift
//  Notes_Sample
//
//  Created by Ashwini on 04/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var noteDetail: String?
    @NSManaged public var title: String?
    @NSManaged public var images: [Data]?

}
