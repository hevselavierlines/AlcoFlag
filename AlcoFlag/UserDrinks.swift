//
//  userdrinks.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 20/06/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import Foundation
/**
* Saves user-defined drinks.
*/
public class UserDrinks {
    var drinks : [Drink]
    /**
    * The initializer loads directly the the drinks from the storage.
    */
    public init() {
        drinks = []
        load()
    }
    /**
    * Loads the created drinks by checking if the image-file still exists.
    * If the image-file doesn't exist anymore the drink is deleted.
    * In the EditController appers the Other-image.
    */
    public init(load : Bool) {
        drinks = []
        self.load()
        
        var needReload = false
        
        for var i = drinks.count - 1; i >= 0; i-- {
            let file = drinks[i].filename
            if NSFileManager.defaultManager().fileExistsAtPath(file) == false {
                drinks.removeAtIndex(i)
                needReload = true
            }
        }
        if needReload {
            save()
        }
    }
    /**
    * Adds a new user-defined drink.
    */
    public func addDrink(_drink : Drink) {
        let number = drinks.count + 1
        _drink.name = _drink.name + " \(number)"
        drinks.append(_drink)
    }
    /**
    * The current amount of drinks.
    */
    public func count() -> Int {
        return drinks.count
    }
    
    public func serialize() -> NSData {
        var serialDrinks = [NSDictionary](count: drinks.count, repeatedValue: NSDictionary())
        for var i = 0; i < drinks.count; i++ {
            serialDrinks[i] = drinks[i].serialize()
        }
        let data = try? NSJSONSerialization.dataWithJSONObject(serialDrinks, options: NSJSONWritingOptions())
        return data!
    }
    
    public func deserialize(_json : NSData) {
        drinks.removeAll(keepCapacity: true)
        let obj = (try! NSJSONSerialization.JSONObjectWithData(_json, options: NSJSONReadingOptions())) as! NSArray
        
        for var i = 0; i < obj.count; i++ {
            let dict = obj[i] as! NSDictionary
            
            drinks.append(Drink(_dict: dict))
        }
    }
    
    func save() {
        let fileManager = NSFileManager.defaultManager()
        let filePath = "\(UserDrinks.documentsDirectory())/userdrinks.af"
        
        fileManager.createFileAtPath(filePath, contents: serialize(), attributes: nil)
    }
    
    func load() {
        let fileManager = NSFileManager.defaultManager()
        let filePath = "\(UserDrinks.documentsDirectory())/userdrinks.af"
        if fileManager.fileExistsAtPath(filePath) {
            let data = NSData(contentsOfFile: filePath)
            deserialize(data!)
        } else {
            //No file found, a new one has to be created.
        }
    }
    
    public static func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] 
        return documentDirectory
    }
}