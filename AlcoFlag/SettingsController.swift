//
//  SettingsController.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 25/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import UIKit

/**
* SettingsController is for setting user-information.
*/
class SettingsController: UIViewController {
    
    @IBOutlet weak var selectWeight: UIPickerView!
    var weights = [Int](count: 230, repeatedValue: 0)

    
    @IBOutlet weak var selectNotification: UISegmentedControl!
    var gender = 1
    var notification = 2
    
    @IBOutlet weak var selectGender: UISegmentedControl!
    var weight = 0
    let userDefault = NSUserDefaults.standardUserDefaults()

    /**
    * On loading the values are loaded and shown.
    * This view is shown on first-start.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        var we = 20
        for var i = 0; i < weights.count; i++ {
            weights[i] = we++
        }
        weight = userDefault.integerForKey("weight")
        if weight > 0 {
            selectWeight.selectRow(weight - 20, inComponent: 0, animated: true)
        }
        
        gender = userDefault.integerForKey("gender")
        if gender > 0 {
            if gender == 2 {
                selectGender.selectedSegmentIndex = 1
            }
        } else {
            gender = 1
        }
        
        notification = userDefault.integerForKey("notify")
        if notification > 0 {
            selectNotification.selectedSegmentIndex = notification - 1
        } else {
            notification = 2
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
    * Clicking on the done-button the values are saved.
    */
    @IBAction func clickDone(sender: AnyObject) {
        userDefault.setInteger(weight, forKey: "weight")
        if selectGender.selectedSegmentIndex == 0 {
            userDefault.setInteger(1, forKey: "gender")
        } else {
            userDefault.setInteger(2, forKey: "gender")
        }
        
        userDefault.setInteger(selectNotification.selectedSegmentIndex + 1, forKey: "notify")
        
        userDefault.synchronize()
        
        if let ng = navigationController {
            ng.popViewControllerAnimated(true)
        }
    }
    
    /**
    * Section in the pickerView
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weights.count
    }
    /**
    * The dataMember for the pickerview.
    */
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let attributedString = NSAttributedString(string: "\(weights[row]) kg", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            return attributedString
     
    }
    /**
    * The delegate for the pickerView setting the value for saving.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weight = weights[row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
