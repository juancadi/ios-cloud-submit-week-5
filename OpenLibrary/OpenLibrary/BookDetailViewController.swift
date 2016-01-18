//
//  BookDetailViewController.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 17/01/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var lblBookIsbn: UILabel!
    
    @IBOutlet weak var lblBookAuthor: UILabel!
    
    @IBOutlet weak var imgBookCover: UIImageView!
    
    var isbnDetailBook : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if isbnDetailBook != nil {
            
            
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let openLibraryCoreDataManager = OpenLibraryCoreDataManager(context: managedContext)
            
            let detailBook = openLibraryCoreDataManager.getRegistersByKey("Books", whereKeyName: "isbn", equalsToKeyValue: isbnDetailBook!)
            
            title = detailBook![0].name
            lblBookIsbn.text = detailBook![0].isbn
            lblBookAuthor.text = detailBook![0].authors
            
            if detailBook![0].imgCover != nil {
            
                imgBookCover.image = UIImage(data: detailBook![0].imgCover!)
            
            }else{
                
                imgBookCover.image = UIImage(named: "poster_not_available");
            }
                
            
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
