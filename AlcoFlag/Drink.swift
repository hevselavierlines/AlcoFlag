//
//  Drink.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 23/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import Foundation

/**
* This class is for saving predefined as well user-defined drinks.
*/
public class Drink {
    var name : String
    var amount : Float
    var percent : Float
    var filename : String
    /**
    * A new drink is created.
    * @param _name The name of the drink
    * @param _amount The amount of the drink (typically in litres)
    * @param _filename The location to the icon-file.
    */
    public init(_name: String, _amount: Float, _percent: Float, _filename: String) {
        name = _name
        amount = _amount
        percent = _percent
        filename = _filename
    }
    /**
    * The deserialization is diretly done in the init method
    */
    public init(_dict : NSDictionary) {
        name = _dict["name"] as! String
        amount = _dict["amount"] as! Float
        percent = _dict["percent"] as! Float
        if _dict["filename"] == nil {
            filename = ""
        } else {
            filename = _dict["filename"] as! String
        }
    }
    /**
    * Serialization for saving the drink in memory.
    * @return The serialized NSDictionary.
    */
    func serialize() -> NSDictionary {
        let dict = ["name":name, "amount":amount, "percent":percent, "filename":filename]
        return dict
    }
}
