//
//  Books.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 16/01/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

struct Book {
    
    var isbn: String?
    var name: String?
    var authors: String?
    var urlCover: String?
    var imgCover : NSData?
    
    init(isbn: String?, name: String?, authors: String?, urlCover: String?, imgCover: NSData?) {
        
        self.isbn = isbn
        self.name = name
        self.authors = authors
        self.urlCover = urlCover
        self.imgCover = imgCover
    }
}
