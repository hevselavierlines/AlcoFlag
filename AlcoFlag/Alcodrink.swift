//
//  Alcodrink.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 24/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import Foundation

/**
* A Alcodrink is an extension of Drink.
* It saves the drink as well as the drinking time.
*/
public class Alcodrink {
    var drink : Drink
    
    var drinkTime : NSDate
    
    let dateFormatter = NSDateFormatter()
    /**
    * In the initialization the drinking time and the drink are needed.
    * @param _drink The drink-object
    * @param _drinkTime The time of the drink as NSDate
    */
    public init(_drink: Drink, _drinkTime: NSDate) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        drink = _drink
        drinkTime = _drinkTime
    }
    /**
    * The second initialization is for deserialization.
    * @param _dict The NSDictionary to deserialize.
    */
    public init(_dict: NSDictionary) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString = _dict["drinkTime"] as! String
        drinkTime = dateFormatter.dateFromString(dateString)!
        
        let drinkDict = _dict["drink"] as! NSDictionary
        drink = Drink(_dict: drinkDict)
    }
    /**
    * This method serializes the object to a NSDictionary.
    * Important: The NSDate is converted to a String.
    * @return The serialized NSDictionary.
    */
    public func serialize() -> NSDictionary {
        let dateString = dateFormatter.stringFromDate(drinkTime)
        let dict = ["drink" : drink.serialize(), "drinkTime" : dateString]
        return dict
    }
    /**
    * This method deserializes a given NSDictionary and imports the data to the current object.
    * @param _dict The NSDictionary to parse.
    */
    public func deserialize(_dict : NSDictionary) {
        let dateString = _dict["drinkTime"] as! String
        drinkTime = dateFormatter.dateFromString(dateString)!
        
        //var drinkDict = _dict["drink"] as! NSDictionary
    }
}

