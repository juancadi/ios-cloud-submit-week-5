//
//  OpenLibraryCoreDataManager.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 17/01/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import Foundation
import CoreData


class OpenLibraryCoreDataManager{
    
    var managedContext : NSManagedObjectContext
    
    init(context : NSManagedObjectContext){
        
        self.managedContext = context
        
    }

    
    func saveBook(book: Book) -> Int{
        
        //Error almacenando libro
        var resultSaveBook : Int = 0
        
        let existBook = self.getRegistersByKey("Books", whereKeyName: "isbn", equalsToKeyValue: book.isbn!)
        
        if existBook == nil{
        
            let entityBooks =  NSEntityDescription.entityForName("Books",
            inManagedObjectContext:self.managedContext)
        
            let newBook = NSManagedObject(entity: entityBooks!,
            insertIntoManagedObjectContext: self.managedContext)
        
            do {
            
                newBook.setValue(book.isbn, forKey: "isbn")
                newBook.setValue(book.name, forKey: "name")
                newBook.setValue(book.authors, forKey: "authors")
                newBook.setValue(book.urlCover, forKey: "urlCover")
                newBook.setValue(book.imgCover, forKey: "imgCover")
            
            
                //4.Commit the changes to labels and save to disk by calling save on the managed object context
                try self.managedContext.save()
            
                //Libro almacenado exitosamente
                resultSaveBook = 1
            
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }else{
            // El libro ya existe
            resultSaveBook = 2
        }
        
        return resultSaveBook
    
    
    }
    
    
    func getRegistersByKey(entityName: String, whereKeyName: String, equalsToKeyValue : String) -> [Book]? {
        
        var savedBooks : [Book] = []
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        if !whereKeyName.isEmpty && !equalsToKeyValue.isEmpty
        {
            fetchRequest.predicate = NSPredicate(format: "\(whereKeyName) == %@", equalsToKeyValue)
        }
        
        do {
            let resultGetRegisterById = try self.managedContext.executeFetchRequest(fetchRequest)
            
            let registersFromFetch = resultGetRegisterById as! [NSManagedObject]
            
            let countFetchedRegisters = registersFromFetch.count
        
            
            if countFetchedRegisters == 0{
                
                return nil
                
            }else{
                
                
                for var i=0; i<registersFromFetch.count; i++ {
                    
                    savedBooks.append(Book(isbn: registersFromFetch[i].valueForKey("isbn") as? String,
                    name: registersFromFetch[i].valueForKey("name") as? String,
                    authors: registersFromFetch[i].valueForKey("authors") as? String,
                    urlCover: registersFromFetch[i].valueForKey("urlCover") as? String,
                    imgCover: registersFromFetch[i].valueForKey("imgCover") as? NSData))
                
                
                }
                
                return savedBooks
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            print(">>> PactiaCoreDataManager>> getRegistersById()>> registerToReturn : Entity Name:\(entityName), where \(whereKeyName) = \(equalsToKeyValue)")
            return nil
        }
        
    }

}
