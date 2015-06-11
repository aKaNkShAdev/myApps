//
//  ShowPairsViewController.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 10/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import FBSDKShareKit

class ShowPairsViewController: UIViewController {
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var upper1: UIImageView!
    @IBOutlet weak var lower1: UIImageView!
    @IBOutlet weak var upper2: UIImageView!
    @IBOutlet weak var lower2: UIImageView!
    
    var uppersArray : NSArray = NSArray()
    var lowersArray : NSArray = NSArray()
    var pairsArray : NSMutableArray = NSMutableArray()
    var upperId : Int = 0
    var lowerId : Int = 0
    var upperImagePath : String = ""
    var lowerImagePath : String = ""

    var view1Visible : Bool = true
    var view2Visible  : Bool = false
    var pairsCount : Int = 0
    var leftSwipeCount : Int = 0
    var rightSwipeCount : Int = 0
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right

        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)

        fetchClothes()
        upper1.image = getImageFromPath(pairsArray.objectAtIndex(0).objectForKey("upperImagePath") as! String)
        lower1.image = getImageFromPath(pairsArray.objectAtIndex(0).objectForKey("lowerImagePath") as! String)
        leftSwipeCount = leftSwipeCount + 1
        rightSwipeCount = pairsCount - 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        if(!view2Visible){
            println("celled")
            view2Visible = true
            view2.center = CGPointMake(self.view2.center.x + 4000 , self.view2.center.y)
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
       // println("count before : \(count)")
        
        //if(count <= pairsCount - 1 && count > 0){
        if(leftSwipeCount == pairsCount){
            leftSwipeCount = 0
        }
        
        if(rightSwipeCount == 0){
            rightSwipeCount = pairsCount - 1
        }

            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                println("View : \(self.view.center.x)")
                println("view 1 :: \(self.view1.center.x)")
                println("view 2 :: \(self.view2.center.x)")
                switch swipeGesture.direction {
                    case UISwipeGestureRecognizerDirection.Left:
                        if(leftSwipeCount <= pairsCount - 1){
                            self.upperImagePath = self.pairsArray.objectAtIndex(self.leftSwipeCount).objectForKey("upperImagePath") as! String
                            self.upper1.image = getImageFromPath(self.upperImagePath)
                            self.lowerImagePath = self.pairsArray.objectAtIndex(self.leftSwipeCount).objectForKey("lowerImagePath") as! String
                            self.lower1.image = getImageFromPath(self.lowerImagePath)
                            self.upperId = self.pairsArray.objectAtIndex(self.leftSwipeCount).objectForKey("upperClothId") as! Int
                            self.lowerId = self.pairsArray.objectAtIndex(self.leftSwipeCount).objectForKey("lowerClothId") as! Int
                            leftSwipeCount = leftSwipeCount + 1
                        }
                    case UISwipeGestureRecognizerDirection.Right:
                        if(rightSwipeCount >= 0){
                            self.upperImagePath = self.pairsArray.objectAtIndex(self.rightSwipeCount).objectForKey("upperImagePath") as! String
                            self.upper1.image = getImageFromPath(self.upperImagePath)
                            self.lowerImagePath = self.pairsArray.objectAtIndex(self.rightSwipeCount).objectForKey("lowerImagePath") as! String
                            self.lower1.image = getImageFromPath(self.lowerImagePath)
                            self.upperId = self.pairsArray.objectAtIndex(self.rightSwipeCount).objectForKey("upperClothId") as! Int
                            self.lowerId = self.pairsArray.objectAtIndex(self.rightSwipeCount).objectForKey("lowerClothId") as! Int
                            rightSwipeCount = rightSwipeCount - 1
                        }


                default:
                    break
                }
//                upper1.contentMode = .ScaleAspectFit
//                lower1.contentMode = .ScaleAspectFit
//                upper2.contentMode = .ScaleAspectFit
//                lower2.contentMode = .ScaleAspectFit
            }
            
        //}
        //println("count after : \(count)")

    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func fetchClothes(){
        let entityDescription1 = NSEntityDescription.entityForName("Cloth",inManagedObjectContext: managedObjectContext!)
        
        let uppersRequest = NSFetchRequest()
        uppersRequest.entity = entityDescription1
        
        let pred = NSPredicate(format: "(type_id = %d)", CLOTH_TYPE_UPPER)
        uppersRequest.predicate = pred
        var error: NSError?
        var objects = managedObjectContext?.executeFetchRequest(uppersRequest, error: &error)
        uppersArray = (objects as? NSArray)!
        
        
        let lowersRequest = NSFetchRequest()
        lowersRequest.entity = entityDescription1
        let lowerspred = NSPredicate(format: "(type_id = %d)", CLOTH_TYPE_LOWER)
        lowersRequest.predicate = lowerspred
        var error1: NSError?
        var lowersobjects = managedObjectContext?.executeFetchRequest(lowersRequest,
            error: &error1)
        lowersArray = (lowersobjects as? NSArray)!
        
        generatePairs()
    }
    
    func generatePairs(){
        for ( var i = 0 ; i < uppersArray.count; i++) {
            for ( var j = 0 ; j < lowersArray.count; j++) {
                var pairDict : NSMutableDictionary = NSMutableDictionary()
                var upper : Cloth = uppersArray[i] as! Cloth
                var lower : Cloth = lowersArray[j] as! Cloth
                pairDict.setValue(upper.img_path, forKey: "upperImagePath")
                pairDict.setValue(lower.img_path, forKey: "lowerImagePath")
                pairDict.setValue(upper.cloth_id, forKey: "upperClothId")
                pairDict.setValue(lower.cloth_id, forKey: "lowerClothId")
                pairsArray.addObject(pairDict)
            }
        }
        pairsCount = pairsArray.count
        println("pairs count -- \(pairsArray.count)")
    }
    
    @IBAction func sharePair(sender: AnyObject) {
       UIGraphicsBeginImageContext(sender.superview!!.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = image
        photo.userGenerated = true
        var content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)

    }

    @IBAction func bookMarkPair(sender: AnyObject) {
        let entityDescription =
        NSEntityDescription.entityForName("Pair",
            inManagedObjectContext: managedObjectContext!)
        
        let pair = Pair(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        pair.shirtPath = upperImagePath
        pair.jeansPath = lowerImagePath
        pair.jeans_id = lowerId
        pair.shirt_id = upperId
        pair.status = 1
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            println(error)
        } else {
            println("Saved successfully")
            //performSegueWithIdentifier("showClothes", sender: self)
        }
    }
    
    @IBAction func dislikePair(sender: AnyObject) {
        var swipe = UISwipeGestureRecognizer()
        swipe.direction = UISwipeGestureRecognizerDirection.Left
        respondToSwipeGesture(swipe)
    }
}



