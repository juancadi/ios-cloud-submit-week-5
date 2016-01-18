

//
//  ViewController.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 16/01/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class SearchBookViewController: UIViewController {
    
    
    @IBOutlet weak var txtBookIsbn: UITextField!
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var lblBookAuthors: UILabel!
    @IBOutlet weak var imgBookImage: UIImageView!

    
    var bookInfo: Book? = nil
    var openLibraryManager : OpenLibraryProcessManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.lblBookTitle.hidden = true
        self.lblBookAuthors.hidden = true
        self.imgBookImage.hidden = true
        
        openLibraryManager = OpenLibraryProcessManager()
        bookInfo = nil
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func backgroundTap(sender: UIControl) {
        
        txtBookIsbn.resignFirstResponder()
    }
    
    @IBAction func txtIsbnDoneEditing(sender: UITextField) {
        
        sender.resignFirstResponder()
        
        self.lblBookTitle.hidden = true
        self.lblBookAuthors.hidden = true
        self.imgBookImage.hidden = true
        
        
        if self.txtBookIsbn.text! != ""{
            
            //Función donde se realiza la peticion a OpenLibrary y se procesa la respuesta JSON
            
            bookInfo = openLibraryManager!.getBookInfo(self.txtBookIsbn.text!)
            
            if bookInfo != nil {
                
                self.lblBookTitle.hidden = false
                self.lblBookAuthors.hidden = false
                self.imgBookImage.hidden = false
                
                self.lblBookTitle.text = bookInfo!.name
                self.lblBookAuthors.text = bookInfo!.authors
                
                if bookInfo!.imgCover != nil {
                    
                    self.imgBookImage.image = UIImage(data: bookInfo!.imgCover!)
                
                }else{
                    
                    self.imgBookImage.image = UIImage(named: "poster_not_available");
                
                }
                
            }else{
                
                self.showSingleAlert("Upss!!!", message: "Problems in the connection with openlibrary.org, please check the ISBN and try again!")
            }
            
            
        }else{
            
            self.showSingleAlert("Info...", message: "ISBN empty, please fill it!.")
        }
        
        
    }
    
    
    func showSingleAlert(title:String, message:String){
        
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveBook" {
            
            if bookInfo == nil {
                
                self.showSingleAlert("Warning...", message: "There are not any book to save... You must to enter the ISBN of the book to start the search!")
            
            }
            
        }
    }
    

}

