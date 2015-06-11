//
//  ImageUtil.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 6/9/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import Foundation
import UIKit

func getImageFromURL(var path :String)-> UIImage{
    let url = NSURL(string : path)
    if(url != nil){
        let data = NSData(contentsOfURL: url!)
        if(data != nil){
            return UIImage(data: data!)!
        } else {
            return UIImage(named: "default-user.png")!
        }
    } else {
        return UIImage(named: "default-user.png")!
    }
    
    
    
}

func getImageFromPath(filePath : String) -> UIImage {
    var documentsDirectory : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
    var fullPathToFile2 : NSString = documentsDirectory.stringByAppendingPathComponent(filePath)
    var savedImageData :NSData = NSData(contentsOfFile: fullPathToFile2 as String)!
    return UIImage(data: savedImageData)!

}