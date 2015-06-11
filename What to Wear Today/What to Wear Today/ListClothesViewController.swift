//
//  ListClothesViewController.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 10/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit
import CoreData

class ListClothesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var uppers: UICollectionView!
    @IBOutlet weak var lowers: UICollectionView!
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var startMatchingBtn: UIButton!
    
    var uppersArray : NSArray = NSArray()
    var lowersArray : NSArray = NSArray()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        fetchClothes()
        if(uppersArray.count >= 2 && lowersArray.count >= 2){
            startMatchingBtn.hidden = false
            message.hidden = true
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "hasPairs")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(collectionView == uppers){
            return uppersArray.count
        } else {
            return lowersArray.count
        }
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if(collectionView == uppers){
            let cell : ClothCell = collectionView.dequeueReusableCellWithReuseIdentifier("uppersCell", forIndexPath: indexPath) as! ClothCell
            var cloth:Cloth = uppersArray.objectAtIndex(indexPath.row) as! Cloth
            println(cloth.img_path)
            var documentsDirectory : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            var fullPathToFile2 : NSString = documentsDirectory.stringByAppendingPathComponent(cloth.img_path)
            cell.clothImg.contentMode = .ScaleAspectFit
            
            var savedImageData :NSData = NSData(contentsOfFile: fullPathToFile2 as String)!
            cell.clothImg.image = UIImage(data: savedImageData)
            
            return cell
        } else {
            let cell : ClothCell = collectionView.dequeueReusableCellWithReuseIdentifier("lowersCell", forIndexPath: indexPath) as! ClothCell
            var cloth:Cloth = lowersArray.objectAtIndex(indexPath.row) as! Cloth
            println(cloth.img_path)
            var documentsDirectory : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            var fullPathToFile2 : NSString = documentsDirectory.stringByAppendingPathComponent(cloth.img_path)
            cell.clothImg.contentMode = .ScaleAspectFit
            
            var savedImageData :NSData = NSData(contentsOfFile: fullPathToFile2 as String)!
            cell.clothImg.image = UIImage(data: savedImageData)

            return cell
        }

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func fetchClothes(){
        let entityDescription =
        NSEntityDescription.entityForName("Cloth",
            inManagedObjectContext: managedObjectContext!)
        
        let uppersRequest = NSFetchRequest()
        uppersRequest.entity = entityDescription
        
       let pred = NSPredicate(format: "(type_id = %d)", CLOTH_TYPE_UPPER)
        uppersRequest.predicate = pred
        var error: NSError?
        var objects = managedObjectContext?.executeFetchRequest(uppersRequest,
            error: &error)
        uppersArray = (objects as? NSArray)!
        
        
        let lowersRequest = NSFetchRequest()
        lowersRequest.entity = entityDescription
        let lowerspred = NSPredicate(format: "(type_id = %d)", CLOTH_TYPE_LOWER)
        lowersRequest.predicate = lowerspred
        var error1: NSError?
        var lowersobjects = managedObjectContext?.executeFetchRequest(lowersRequest,
            error: &error1)
        lowersArray = (lowersobjects as? NSArray)!
        
        /*if let results = objects {
            
            if results.count > 0 {
                let match = results[0] as! NSManagedObject
                var fetchedCloth : Cloth =  match as! Cloth


            } else {
                println("No macthes found")
            }
        }*/
        uppers.reloadData()
        lowers.reloadData()

    }
    

    
}
