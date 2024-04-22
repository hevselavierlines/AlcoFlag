//
//  DrinkManager.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 24/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import Foundation

/**
* The DrinkManager is the main-container and provides the calculations.
* An array is the data-member that containts all drinks.
*/
public class DrinkManager {
    var drinks : [Alcodrink] = []
    /**
    * On init the saved data are reloaded
    */
    public init() {
        load()
    }
    /**
    * For testing a different initializer is needed.
    * Without load can be true and false.
    */
    public init(withoutLoad: Bool) {}
    /**
    * A new Alcodrink will be added to the array, but the insert is done with an
    * ascending order. The condition for the order is the drinkTime.
    * @param _drink The Alcodrink to add.
    */
    public func addDrink(_drink: Alcodrink) {
        var pos = -1
        let newDrink = _drink.drinkTime
        for var i = drinks.count - 1; i >= 0 && pos < 0; i-- {
            let time = drinks[i].drinkTime
            if time.compare(newDrink) == NSComparisonResult.OrderedAscending {
                pos = i + 1
            }
        }
        if pos == -1 {
            pos = 0
        }
        drinks.insert(_drink, atIndex: pos)
    }
    /**
    * The current amount of drinks
    * @return The current amount of drinks as Int.
    */
    public func count() -> Int {
        return drinks.count
    }
    /**
    * Gets the time of a particular drink by it's position.
    * @param _id The id of the drink (index)
    * @return The NSDate object of the particular drink.
    */
    public func getTimeOfDrinkId(_id : Int) -> NSDate {
        return drinks[_id].drinkTime
    }
    /**
    * Removes the drink with the particular index.
    * @param _pos The position of the drink.
    */
    public func removeDrinkIndex (_pos: Int) {
        drinks.removeAtIndex(_pos)
    }
    /**
    * Serializes the full array directly to a NSData object.
    * @return The serialized NSData.
    */
    public func serialize() -> NSData {
        var serialDrinks = [NSDictionary](count: drinks.count, repeatedValue: NSDictionary())
        for var i = 0; i < drinks.count; i++ {
            serialDrinks[i] = drinks[i].serialize()
        }
        let data = try? NSJSONSerialization.dataWithJSONObject(serialDrinks, options: NSJSONWritingOptions())
        return data!
    }
    /**
    * Deserializes the NSData directly and imports it into the current object.
    * @param _json The json data.
    */
    public func deserialize(_json : NSData) {
        drinks.removeAll(keepCapacity: true)
        let obj = (try! NSJSONSerialization.JSONObjectWithData(_json, options: NSJSONReadingOptions())) as! NSArray
        
        for var i = 0; i < obj.count; i++ {
            let dict = obj[i] as! NSDictionary
            
            drinks.append(Alcodrink(_dict: dict))
        }
    }
    /**
    * Is used to sort the array by date.
    * Used before smart insert.
    */
    func sort() {
        let orderClosure = { (d1:Alcodrink, d2:Alcodrink) -> Bool in
            d1.drinkTime.timeIntervalSinceNow < d2.drinkTime.timeIntervalSinceNow
        }
        drinks.sortInPlace(orderClosure)
    }
    /**
    * Saves the current DrinkManager as JSON to the documents-directory of the app.
    */
    func save() {
        let fileManager = NSFileManager.defaultManager()
        let filePath = "\(documentsDirectory())/drinks.af"
        
        fileManager.createFileAtPath(filePath, contents: serialize(), attributes: nil)
    }
    /**
    * Loads the last drinks-file from the storage and imports it.
    * If the file is not available nothing will be loaded.
    */
    func load() {
        let fileManager = NSFileManager.defaultManager()
        let filePath = "\(documentsDirectory())/drinks.af"
        if fileManager.fileExistsAtPath(filePath) {
            let data = NSData(contentsOfFile: filePath)
            deserialize(data!)
        } else {
            //No file found, a new one has to be created.
        }
    }
    /**
    * Calculates the current BAC (Blood Alcohol Content) with the Widmark-Formula.
    * @param _weight The weight of the client in kg
    * @param _gender The gender (1 is male, 2 is female)
    * @return The current BAC in permille.
    */
    public func calculateBAC(_weight: Int, _gender: Int) -> Float {
        let now = NSDate(timeIntervalSinceNow: 0)
        var bacDrinks = [Double](count: drinks.count, repeatedValue: 0.0)
        //var userDefaults = NSUserDefaults.standardUserDefaults()
        var persWeight = 60.0
        if _gender == 1 {
            persWeight = Double(_weight) * 0.7
        } else {
            persWeight = Double(_weight) * 0.6
        }
        
        var alc = 0.0
        for var i = 0; i < drinks.count; i++ {
            let volumina = Double((drinks[i].drink.amount * 1000) * (drinks[i].drink.percent / 100) * 0.8)
            bacDrinks[i] = volumina / persWeight
        }
        if bacDrinks.count == 1 {
            let diff = Double(now.timeIntervalSinceDate(drinks[0].drinkTime)) / 3600
            if diff > 0 {
                bacDrinks[0] -= (diff * 0.15)
            }
            for var i = 0; i < bacDrinks.count; i++ {
                if bacDrinks[i] > 0 {
                    alc += bacDrinks[i]
                }
            }
        } else if bacDrinks.count > 1 {
            var builtDown = 0
            for var i = 0; i < drinks.count - 1; i++ {
                let diffNow = Double(now.timeIntervalSinceDate(drinks[i].drinkTime) / 3600)
                let diffNext = Double(drinks[i + 1].drinkTime.timeIntervalSinceDate(drinks[i].drinkTime) / 3600)
                if diffNow > diffNext {
                    bacDrinks[i] -= (diffNext * (0.15 / Double(i + 1 - builtDown)))
                } else {
                    bacDrinks[i] -= (diffNow * (0.15 / Double(i + 1 - builtDown)))
                }
                for var j = i + 2; j < drinks.count; j++ {
                    let diffNext = Double(drinks[j].drinkTime.timeIntervalSinceDate(drinks[j - 1].drinkTime) / 3600)
                    bacDrinks[i] -= (diffNext * (0.15 / Double(j - builtDown)))
                }
                if bacDrinks[i] <= 0 {
                    builtDown++
                }
            }
            for var i = 0; i < bacDrinks.count; i++ {
                if bacDrinks[i] > 0.0 {
                    alc += bacDrinks[i]
                }
            }
            let diffLast = Double(now.timeIntervalSinceDate(drinks[drinks.count - 1].drinkTime) / 3600)
            if diffLast > 0 {
                alc -= (diffLast * 0.15)
            }
        }
        if alc <= 0.0 {
            alc = 0.0
        }
        
        return Float(alc)
    }
    /**
    * Calculates the BAC by using the NSUserDefaults.
    * Calls the method with the weight and gender argument.
    * The method uses standard values if the values haven't be already set.
    * @return The current BAC.
    */
    public func calculateBAC() -> Float {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var weight = 60
        var gender = 1
        gender = userDefaults.integerForKey("gender")
        weight = userDefaults.integerForKey("weight")
        
        if gender == 0 {
            gender = 1
        }
        if weight == 0 {
            weight = 60
        }
        
        return calculateBAC(weight, _gender: gender)
    }
    /**
    * With the BAC the app also calculates when the client is sober again.
    * @param alcMirror The current BAC.
    * @return The sober-time as NSDate
    */
    public func calculateSoberAt(alcMirror : Float) -> NSDate {
        return NSDate(timeIntervalSinceNow: Double(alcMirror / 0.15 * 3600))
    }
    /**
    * Gets the document-directory of the app.
    */
    public func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] 
        return documentDirectory
    }
}