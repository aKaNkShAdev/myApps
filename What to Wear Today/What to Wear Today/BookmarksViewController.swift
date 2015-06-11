//
//  BookmarksViewController.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 11/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit
import CoreData

class BookmarksViewController: UIViewController , UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var bookmarks: UICollectionView!
    
    
    var bookMarkedPairs : NSArray = NSArray()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        fetchClothes()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return bookMarkedPairs.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
            let cell : BookMarkCell = collectionView.dequeueReusableCellWithReuseIdentifier("bookMarkCell", forIndexPath: indexPath) as! BookMarkCell
            var pair : Pair = bookMarkedPairs.objectAtIndex(indexPath.row) as! Pair

            cell.upperImg.contentMode = .ScaleAspectFit
            cell.loweImg.contentMode = .ScaleAspectFit
            cell.upperImg.image = getImageFromPath(pair.shirtPath as String)
            cell.loweImg.image = getImageFromPath(pair.jeansPath as String)

            return cell
            
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func fetchClothes(){
        let entityDescription =
        NSEntityDescription.entityForName("Pair",
            inManagedObjectContext: managedObjectContext!)
        
        let uppersRequest = NSFetchRequest()
        uppersRequest.entity = entityDescription
        var error: NSError?
        var objects = managedObjectContext?.executeFetchRequest(uppersRequest,
            error: &error)
        bookMarkedPairs = (objects as? NSArray)!
        bookmarks.reloadData()
        
    }

}
