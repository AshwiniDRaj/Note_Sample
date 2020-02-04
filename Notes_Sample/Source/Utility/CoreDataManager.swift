//
//  CoreDataManager.swift
//  Notes_Sample
//
//  Created by Ashwini on 03/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let manager : CoreDataManager = CoreDataManager()
    private var managedObjectContext : NSManagedObjectContext
    var notes : [Note]?
    
    private override init() {
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func addNote(title:String, detail:String, creationDate:Date, images : [Data]) {
                
        _ = Note.init(title: title, detail: detail, creationDate: creationDate, moc: managedObjectContext, images: images)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            // TODO error handling
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func editNote(id : UUID, title:String, detail:String, creationDate:Date, images : [Data]) {
        if let notes = fetchNote(noteID: id), notes.count > 0 {
            do {
                let noteManagedObjectToBeChanged = notes[0]
                noteManagedObjectToBeChanged.setValue(title, forKey: "title")
                noteManagedObjectToBeChanged.setValue(detail, forKey: "noteDetail")
                noteManagedObjectToBeChanged.setValue(creationDate, forKey: "creationDate")
                noteManagedObjectToBeChanged.setValue(images, forKey: "images")

                // save
                try managedObjectContext.save()

            } catch let error as NSError {
                // TODO error handling
                print("Could not change. \(error), \(error.userInfo)")
            }
        }
        
    }

    func deleteNoteFromCoreData(idToBeDeleted:UUID) {
        
        if let notes = fetchNote(noteID: idToBeDeleted), notes.count > 0 {
            managedObjectContext.delete(notes[0])
            do {
                try managedObjectContext.save()
                self.fetchNotes()
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func fetchNotes() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sort = NSSortDescriptor(key: #keyPath(Note.creationDate), ascending: false)
        fetchRequest.sortDescriptors = [sort]

        do {
            self.notes = try managedObjectContext.fetch(fetchRequest) as? [Note]
        } catch let error as NSError {
            // TODO error handling
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchNote(noteID : UUID) -> [Note]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let noteIdPredicate = NSPredicate(format: "id == %@", noteID as CVarArg)
        fetchRequest.predicate = noteIdPredicate
        
        do {
            return try managedObjectContext.fetch(fetchRequest) as? [Note]
        } catch let error as NSError {
            // TODO error handling
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
