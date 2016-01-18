//
//  OopenLibraryProcessManager.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 16/01/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit


class OpenLibraryProcessManager{
    
    
    var syncHttpConnetion = SyncHttpConnection()
    
    
    func getBookInfo(bookIsbn : String) -> Book? {
        
        var bookToReturn : Book? = nil
    
        let stringUrl = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=\(bookIsbn)"
        
        let openLibraryResponse = syncHttpConnetion.sendByGet(stringUrl, keyValueParameters: nil)
        
        var responseData : NSString?
        
        if openLibraryResponse != nil {
            
            responseData = NSString(data: openLibraryResponse!, encoding: NSUTF8StringEncoding)
            print("Respuesta obtenida desde openlibrary.org: \n\t \(responseData!)")
            
            if responseData != "{}" {
                
                
                do{
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(openLibraryResponse!, options: NSJSONReadingOptions.MutableLeaves)
                    
                    let responseObject = jsonResponse as! NSDictionary
                    let infoBook = responseObject["\(bookIsbn)"]! as! NSDictionary
                    
                    //Se extrae el titulo
                    let bookTitle = infoBook["title"]! as! NSString as String
                    
                    var bookAuthors : String = ""
                    
                    //Se extrae nombre de los autores
                    if let autores = infoBook["authors"] as? [[String: AnyObject]] {
                        for autor in autores {
                            if let name = autor["name"] as? String {
                                bookAuthors += "\(name), "
                            }
                        }
                        
                        bookAuthors.substringToIndex(bookAuthors.endIndex.advancedBy(-2))
                        
                    }
                    
                    var bookImgCover : NSData? = nil
                    var bookUrlCover : String = ""
                    //var imageDataPortable : NSData? = nil
                    
                    //Se descarga portada si existe alguna asociada al libro
                    if let covers = infoBook.valueForKey("cover"){
                        
                        bookUrlCover = covers["medium"]! as! NSString as String
                        print("URL COVER: \(bookUrlCover)")
                        
                        let imgResponse = syncHttpConnetion.downloadImage(bookUrlCover)
                        if imgResponse.success{
                            
                            if bookUrlCover.containsString(".jpg"){
                                
                                bookImgCover = UIImageJPEGRepresentation(imgResponse.image!, 1)!
                                
                            }else {
                                
                                bookImgCover = UIImagePNGRepresentation(imgResponse.image!)!
                            }

                            
                        }
                        
                    }
                    
                    
                    bookToReturn = Book(isbn: bookIsbn, name: bookTitle, authors: bookAuthors, urlCover: bookUrlCover, imgCover: bookImgCover)
                    
                }catch _{
                    
                    print("Error Serializando JSON")
                    //alert
                    bookToReturn = nil
                    
                }
                
            }
            
        }
        
        
        return bookToReturn
    
    }
    
    
    
}


