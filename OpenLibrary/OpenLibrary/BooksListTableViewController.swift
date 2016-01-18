//
//  BooksListTableViewController.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 16/01/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class BooksListTableViewController: UITableViewController {
    
    var books:[Book] = []
    var isbnSelectedBook : String?
    var openLibraryCoreDataManager : OpenLibraryCoreDataManager? = nil
    
    var booksData = [
        Book(isbn:"9780006479888", name:"A Game of Thrones", authors:"George R. R. Martin", urlCover: "https://covers.openlibrary.org/b/id/7290991-L.jpg", imgCover: nil),
        Book(isbn:"9780788789540", name: "The Lord of the Rings", authors: "J. R. R. Tolkien", urlCover: "https://covers.openlibrary.org/b/id/549853-L.jpg", imgCover: nil),
        Book(isbn:"0563533196", name: "Harry Potter", authors: "J. K. Rowling", urlCover: "https://covers.openlibrary.org/b/id/2520432-L.jpg", imgCover: nil) ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        openLibraryCoreDataManager = OpenLibraryCoreDataManager(context: managedContext)
        
        var imageDataPortable : NSData? = nil
        
        for var i = 0; i < booksData.count; i++ {
            
            let existBook = openLibraryCoreDataManager!.getRegistersByKey("Books", whereKeyName: "isbn", equalsToKeyValue: booksData[i].isbn!)
            
            if existBook == nil{
                
                let syncHttp = SyncHttpConnection()
                let imgCoverResponse = syncHttp.downloadImage(booksData[i].urlCover!)
            
                if imgCoverResponse.success{
                    
                    if booksData[i].urlCover!.containsString(".jpg"){
                        
                        imageDataPortable = UIImageJPEGRepresentation(imgCoverResponse.image!, 1)!
                        booksData[i].imgCover = imageDataPortable
                        
                    }else {
                        
                        imageDataPortable = UIImagePNGRepresentation(imgCoverResponse.image!)!
                        booksData[i].imgCover = imageDataPortable
                    }
                
                }else{
                    
                    booksData[i].imgCover = nil
                }
                
                openLibraryCoreDataManager!.saveBook(booksData[i])
                
            }
        
        }
        
        books = openLibraryCoreDataManager!.getRegistersByKey("Books", whereKeyName: "", equalsToKeyValue: "")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelSearch(segue:UIStoryboardSegue) {
        
        print("inside cancelSearch()")
        
    }
    
    @IBAction func saveBook(segue:UIStoryboardSegue) {
        
        print("inside saveBook()")
        
        if let searchBookViewController = segue.sourceViewController as? SearchBookViewController {
            
            //add the new book to the books array
            
            let newBook = searchBookViewController.bookInfo
            
            if newBook != nil {
                
                let resultSave = openLibraryCoreDataManager!.saveBook(newBook!)
                
                switch resultSave{
                
                case 0:
                    
                    self.showSingleAlert("Upss!!!", message: "Problems while saving the book, please try again!")
                    
                    break
                    
                case 1:
                    
                    books = openLibraryCoreDataManager!.getRegistersByKey("Books", whereKeyName: "", equalsToKeyValue: "")!
                    
                    //update the tableView
                    let indexPath = NSIndexPath(forRow: books.count-1, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    break
                    
                case 2:
                    
                    self.showSingleAlert("Warning...", message: "The book searched is already in your Data Base, you can try with another ISBN.")
                    
                    break
                    
                default:
                    break
                    
                }
                
                
            }
        }
    }
    
    
    
    func showSingleAlert(title:String, message:String){
        
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return books.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let book = books[indexPath.row] as! Book
        
        cell.textLabel!.text = book.name

        return cell
    }
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        isbnSelectedBook = books[indexPath.row].isbn
        
        performSegueWithIdentifier("BookDetail", sender: self)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //let indexPath = T
        //selectedBook = books[indexPath.row]
        
        if segue.identifier == "BookDetail" {
        
            
            let bookDetailController = segue.destinationViewController as! BookDetailViewController
            bookDetailController.isbnDetailBook = self.isbnSelectedBook
            
            
        }
        
    }
    
    
    

}
