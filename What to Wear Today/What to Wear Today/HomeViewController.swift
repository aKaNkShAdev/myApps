//
//  HomeViewController.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 09/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class HomeViewController: UIViewController , UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    @IBOutlet weak var takePictureBtn: UIButton!
    @IBOutlet weak var addUpper: UIButton!
    @IBOutlet weak var addLower: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var savedImageView: UIView!
    @IBOutlet weak var savedImage: UIImageView!

    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var newMedia: Bool?
    var imagePicker = UIImagePickerController()
    var IMAGE_COUNTER : Int = 0
    var clothTypeId : Int = 0
    var imgPath : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(NSUserDefaults.standardUserDefaults().objectForKey("image_counter") != nil){
            IMAGE_COUNTER = NSUserDefaults.standardUserDefaults().objectForKey("image_counter") as! Int
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        savedImageView.center = CGPointMake(self.savedImageView.center.x + 4000 , self.savedImageView.center.y)
    }
    
    @IBAction func savephoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var img : UIImage = UIImage()
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            dismissViewControllerAnimated(true, completion: nil)
            IMAGE_COUNTER = IMAGE_COUNTER + 1;
            NSUserDefaults.standardUserDefaults().setObject(IMAGE_COUNTER, forKey: "image_counter")
            NSUserDefaults.standardUserDefaults().synchronize()
            // Get the data for the image
            var imageData : NSData = UIImageJPEGRepresentation(pickedImage, 1.0)
            
            // Give a name to the file
            var incrementedImgStr : NSString = NSString(format: "Img_%d.jpg",IMAGE_COUNTER)
            
            var documentsDirectory : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
            
            var fullPathToFile2 : NSString = documentsDirectory.stringByAppendingPathComponent(incrementedImgStr as String)
            imgPath = incrementedImgStr as String
            imageData.writeToFile(fullPathToFile2 as String, atomically: false)
            var savedImageData :NSData = NSData(contentsOfFile: fullPathToFile2 as String)!
            imageView.image = UIImage(data: savedImageData)
            if(picker.sourceType == UIImagePickerControllerSourceType.Camera){
                UIImageWriteToSavedPhotosAlbum(UIImage(data: savedImageData), nil, nil, nil)
            }
            saveImageDetails(picker)
            continueBtn.hidden = false
        }
    }
    
    
    @IBAction func showSavedImage(sender: AnyObject) {
        var documentsDirectory : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        var fullPathToFile2 : NSString = documentsDirectory.stringByAppendingPathComponent("Img_1.jpg")
        
        var savedImageData :NSData = NSData(contentsOfFile: fullPathToFile2	 as! String)!
        self.savedImage.image = UIImage(data: savedImageData)
        UIView.animateWithDuration(1.0 as NSTimeInterval, animations: {
            self.savedImageView.center = CGPointMake(self.savedImageView.center.x - 4000 , self.savedImageView.center.y)
            }, completion: {
                finished in

        })
    }
    
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, 
                    completion: nil)
                newMedia = true
        }
    }
    
    @IBAction func addUppers(sender: AnyObject) {
        clothTypeId = CLOTH_TYPE_UPPER
        chooseBuuton.hidden = false
        takePictureBtn.hidden = false
        addLower.hidden = true
    }
    @IBAction func addLowers(sender: AnyObject) {
        clothTypeId = CLOTH_TYPE_LOWER
        chooseBuuton.hidden = false
        takePictureBtn.hidden = false
        addUpper.hidden = true

    }
    
    @IBAction func saveImageDetails(sender: AnyObject){
        let entityDescription =
        NSEntityDescription.entityForName("Cloth",
            inManagedObjectContext: managedObjectContext!)
        
        let cloth = Cloth(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        cloth.img_path = imgPath
        cloth.type_id = clothTypeId
        cloth.cloth_id = IMAGE_COUNTER
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            println(error)
        } else {
            println("Saved successfully")
            //performSegueWithIdentifier("showClothes", sender: self)
        }
    }
    
    
    
    /*func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool){
    if(doneBtn == nil){
    
    doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "saveImagesDone:")
    }
    
    viewController.navigationItem.rightBarButtonItem = doneBtn
    }
    
    @IBAction func saveImagesDone(sender: AnyObject) {
    
    dismissViewControllerAnimated(true, completion: nil)
    
    }*/
    
    //    - (IBAction)SavePhotoOnClick:(id)sender{
    //        UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
    //    }

}
