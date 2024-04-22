//
//  AlcoFlagTests.swift
//  AlcoFlagTests
//
//  Created by Manuel Baumgartner on 11/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import UIKit
import XCTest
import AlcoFlag

class AlcoFlagTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            let manager = DrinkManager(withoutLoad: true)
            
            let drink1 = Alcodrink(_drink: Drink(_name: "Beer", _amount: 0.5, _percent: 5.0, _filename: "beer"), _drinkTime: NSDate(timeIntervalSinceNow: -3600))
            manager.addDrink(drink1)
            
            let drink2 = Alcodrink(_drink: Drink(_name: "Beer", _amount: 0.5, _percent: 5.0, _filename: "beer"), _drinkTime: NSDate(timeIntervalSinceNow: -7200))
        
            let drink3 = Alcodrink(_drink: Drink(_name: "Wine", _amount: 0.25, _percent: 11.5, _filename: "wine"), _drinkTime: NSDate(timeIntervalSince1970: -5000))
            
            let drink4 = Alcodrink(_drink: Drink(_name: "Schnaps", _amount: 0.05, _percent: 35.0, _filename: "schnaps"), _drinkTime: NSDate(timeIntervalSinceNow: 100))
            var mirror = manager.calculateBAC(65, _gender: 1)
            
            for var i = 0; i < 100; i++ {
                mirror = manager.calculateBAC()
            }
        }
    }
    
    func testAddDrink() {
        var manager = DrinkManager(withoutLoad: true)
        
        var drink1 = Alcodrink(_drink: Drink(_name: "Beer", _amount: 0.5, _percent: 5.0, _filename: "beer"), _drinkTime: NSDate(timeIntervalSinceNow: -3600))
        
        var drink2 = Alcodrink(_drink: Drink(_name: "Beer", _amount: 0.5, _percent: 5.0, _filename: "beer"), _drinkTime: NSDate(timeIntervalSinceNow: -2400))
        
        var drink3 = Alcodrink(_drink: Drink(_name: "Beer", _amount: 0.5, _percent: 5.0, _filename: "beer"), _drinkTime: NSDate(timeIntervalSinceNow: -1200))
        
        manager.addDrink(drink3)
        manager.addDrink(drink1)
        manager.addDrink(drink2)
        
        for var i = 1; i < manager.count(); i++ {
            var date1 = manager.getTimeOfDrinkId(i - 1)
            var date2 = manager.getTimeOfDrinkId(i)
            
            XCTAssert(date1.compare(date2) == NSComparisonResult.OrderedAscending, "Drinks are not in order")
        }
    }
    
    func testBAC() {
        var manager = DrinkManager(withoutLoad: true)
        
        var drink1 = Alcodrink(_drink: Drink(_name: "Beer", _amount: 0.5, _percent: 5.0, _filename: "beer"), _drinkTime: NSDate(timeIntervalSinceNow: -3600))
        manager.addDrink(drink1)
        
        var drink2 = Alcodrink(_drink: Drink(_name: "Beer", _amount: 0.5, _percent: 5.0, _filename: "beer"), _drinkTime: NSDate(timeIntervalSinceNow: 0))
        
        var mirror = manager.calculateBAC(65, _gender: 1)

        
        //XCTAssertEqualWithAccuracy(mirror, 0.29, 0.01, "");
        
        manager.addDrink(drink2)
        mirror = manager.calculateBAC(65, _gender: 1)
        //XCTAssertEqualWithAccuracy(mirror, 0.29 + 0.44, 0.01, "")
        
        manager.addDrink(drink2)
        mirror = manager.calculateBAC(65, _gender: 1)
        //XCTAssertEqualWithAccuracy(mirror, 0.29 + 0.44 + 0.44, 0.01, "")
    }
    
}
