//
//  AddDrinkController.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 20/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import UIKit

class AddDrinkController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbPercent: UILabel!
    @IBOutlet weak var selector: UIPickerView!
    @IBOutlet weak var tbPercent: UIButton!
    @IBOutlet weak var drinkColl: UICollectionView!
    @IBOutlet weak var tbAmount: UIButton!
    
    @IBOutlet weak var veBlurBar: UIVisualEffectView!
    @IBOutlet weak var selectDate: UIDatePicker!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var tbTime: UIButton!
    @IBOutlet weak var btAdd: UIBarButtonItem!
    
    @IBOutlet weak var btOK: UIButton!
    @IBOutlet weak var btReset: UIButton!
    let reuseIdentifier = "drinks"
    
    var selectorIs : [Float] = [0]
    var selPercent : Int = 0
    var selAmount : Int = 0
    var selTime : NSDate?
    var selDrink = "other"
    var selDrinkId = -1
    var selDrinkSesction = -1
    var origPosPick = CGRectMake(0, 0, 0, 0)
    var lastSelection : NSIndexPath?
    var state = 0
    var editId = -1
    
    var mode = 0
    var newImage : UIImage?
    /**
    * All predefined Drinks are here.
    * All drinks exept by brand names are localized.
    */
    var predefDrinks = [
        Drink(_name: NSLocalizedString("beer", comment: "beer"), _amount: 0.5, _percent: 5.0, _filename: "beer"),
        Drink(_name: NSLocalizedString("stieglbeer", comment: "stiegl"), _amount: 0.5, _percent: 4.9, _filename: "stiegl"),
        Drink(_name: "Duvel Beer", _amount: 0.33, _percent: 8.5, _filename: "duvel"),
        Drink(_name: "Guinnes", _amount: 0.33, _percent: 4.5, _filename: "guinnes"),
        Drink(_name: NSLocalizedString("wheatbeer", comment: "Weizenhoibe"), _amount: 0.5, _percent: 5.5, _filename: "wheatbeer"),
        Drink(_name: NSLocalizedString("radler", comment: "radler"), _amount: 0.5, _percent: 2.5, _filename: "radler"),
        Drink(_name: NSLocalizedString("wine", comment: "wine"), _amount: 0.125, _percent: 11.5, _filename: "wine"),
        Drink(_name: NSLocalizedString("schnaps", comment: "schnaps"), _amount: 0.05, _percent: 35.0, _filename: "schnaps"),
        Drink(_name: NSLocalizedString("vodka", comment: "vodka"), _amount: 0.02, _percent: 40.0, _filename: "vodka"),
        Drink(_name: NSLocalizedString("huntermaster", comment: "huntermaster"), _amount: 0.02, _percent: 35.0, _filename: "huntermaster"),
        Drink(_name: NSLocalizedString("whisky", comment: "whisky"), _amount: 0.05, _percent: 45.0, _filename:"whisky"),
        Drink(_name: NSLocalizedString("longisland", comment: "longisland"), _amount: 0.25, _percent: 6.5, _filename: "longislandicetea"),
        Drink(_name: NSLocalizedString("krainer", comment: "krainer"), _amount: 0.25, _percent: 7.0, _filename: "krainer"),
        Drink(_name: NSLocalizedString("pinacolada", comment: "pinacolada"), _amount: 0.25, _percent: 5.5, _filename: "pinacolada"),
        Drink(_name: NSLocalizedString("seabreeze", comment: "seabreeze"), _amount: 0.25, _percent: 6.0, _filename: "seabreeze"),
        Drink(_name: NSLocalizedString("swimmingpool", comment: "swimmingpool"), _amount: 0.25, _percent: 6.0, _filename: "swimmingpool"),
        Drink(_name: NSLocalizedString("caipirinha", comment: "caipirinha"), _amount: 0.15, _percent: 6.0, _filename: "caipirinha"),
        Drink(_name: "Tequila Sunrise", _amount: 0.15, _percent: 12.0, _filename: "tequila_sunrise"),
        Drink(_name: NSLocalizedString("other", comment: "other"), _amount: 0.01, _percent: 0.5, _filename: "other")
    ]
    
    let amount : [Float] = [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.125, 0.15, 0.2,
        0.25 ,0.3,0.33,0.4,0.5,0.6,0.75, 1, 1.25, 1.5, 1.75, 2]
    
    var percent : [Float] = [Float](count: 196, repeatedValue: 0.0)
    
    var count = 0
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    /**
    * Edit-mode uses the same ViewController with different settings.
    * Before editing this method has to be called.
    * @param _editId The id of the drink to be edited.
    * @param selDrink The name of the selected drink.
    * @param _percent The percentage of the drink.
    * @param _amount The amount of the drink.
    * @param _drinkTime The NSDate time.
    */
    func editMode(_editId: Int, selDrink : String, _percent: Float, _amount: Float, _drinkTime: NSDate) {
        selDrinkId = -1
        editId = _editId
        for var i = 0; i < predefDrinks.count && selDrinkId < 0; i++ {
            if selDrink == predefDrinks[i].name {
                selDrinkId = i
                selDrinkSesction = 0
            }
        }
        for var i = 0; i < appDelegate.userDrinks!.count() && selDrinkId < 0; i++ {
            if selDrink == appDelegate.userDrinks!.drinks[i].name {
                selDrinkId = i
                selDrinkSesction = 1
            }
        }
        lastSelection = NSIndexPath(forItem: selDrinkId, inSection: selDrinkSesction)
        var per : Float = 0.5
        for var i = 0; i < percent.count; i++ {
            percent[i] = per
            per += 0.5
        }
        selTime = _drinkTime
        
        if selDrinkId == -1 {
            selDrinkSesction = 0
            selDrinkId = predefDrinks.count - 1
        }
        
        selectPercent(_percent)
        selectAmount(_amount)
    }
    /**
    * The stateChange is important for the animated appearence of the PickerView.
    * @param _state The state determines the appearance of the elements.
    *               0 = No pickerview just the normal view.
    *               1 = The alcohol-percentage PickerView is shown.
    *               2 = The drink-amount PickerView is shown.
    *               3 = The DateTime-picker is shown.
    */
    func stateChange(_state : Int) {
        if _state > 0 {
            
            if _state == 1 {
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.btOK.alpha = 1.0
                    self.tbTime.alpha = 0.0
                    self.tbAmount.alpha = 0.0
                    self.tbPercent.alpha = 0.0
                    
                    self.lbTime.alpha = 0.0
                    self.lbPercent.alpha = 1.0
                    self.lbAmount.alpha = 0.0
                    self.view.bringSubviewToFront(self.lbPercent)
                    
                    self.selector.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.veBlurBar.transform = CGAffineTransformMakeTranslation(0, 0)
                })
            } else if _state == 2 {
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.btOK.alpha = 1.0
                    self.tbTime.alpha = 0.0
                    self.tbAmount.alpha = 0.0
                    self.tbPercent.alpha = 0.0
                    
                    self.lbTime.alpha = 0.0
                    self.lbPercent.alpha = 0.0
                    self.lbAmount.alpha = 1.0
                    self.view.bringSubviewToFront(self.lbAmount)
                    
                    self.selector.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.veBlurBar.transform = CGAffineTransformMakeTranslation(0, 0)
                })
            } else if _state == 3 {
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.btOK.alpha = 1.0
                    self.tbTime.alpha = 0.0
                    self.tbAmount.alpha = 0.0
                    self.tbPercent.alpha = 0.0
                    
                    self.lbTime.alpha = 1.0
                    self.lbPercent.alpha = 0.0
                    self.lbAmount.alpha = 0.0
                    self.view.bringSubviewToFront(self.lbTime)
                    
                    self.selectDate.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.veBlurBar.transform = CGAffineTransformMakeTranslation(0, 0)
                })
                
            }
            
        } else {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.selectDate.transform = CGAffineTransformMakeTranslation(0, 250)
                self.selector.transform = CGAffineTransformMakeTranslation(0, 250)
                self.veBlurBar.transform = CGAffineTransformMakeTranslation(0, 250)
                
                self.btOK.alpha = 0.0
                self.tbTime.alpha = 1.0
                self.tbAmount.alpha = 1.0
                self.tbPercent.alpha = 1.0
                
                self.lbTime.alpha = 1.0
                self.lbPercent.alpha = 1.0
                self.lbAmount.alpha = 1.0
            })
        }
    }
    /**
    * When the uses clicks the add-button.
    * The selection is checked.
    *   - No selection: Alert
    *   - Selection: Drink is added to the DrinkManager.
    *   - new Drink: The new created drink will be added to the UserDrinks.
    */
    @IBAction func clickAdd(sender: AnyObject) {
        var finished = true
        if selDrinkId >= 0 {
            if appDelegate.drinkManager == nil {
                appDelegate.drinkManager = DrinkManager()
            }
            
            
            var newDrink : Drink? = nil
            if selDrinkSesction <= 0 && selDrinkId == count - 1 {
                if(newImage != nil) {
                    newDrink = saveDrink()
                } else {
                    finished = false
                }
            } else {
                var file = ""
                if selDrinkSesction == 0 {
                    file = predefDrinks[selDrinkId].filename
                
                } else {
                    file = appDelegate.userDrinks!.drinks[selDrinkId].filename
                }
                newDrink = Drink(_name: selDrink, _amount: amount[selAmount], _percent: percent[selPercent], _filename: file)
            }
            if finished {
                let alcoDrink = Alcodrink(_drink: newDrink!, _drinkTime: selTime!)
        
                appDelegate.drinkManager?.addDrink(alcoDrink)
                appDelegate.drinkManager?.save()
            }
        }
        
        else {
            finished = false
        }
        
        if finished {
            navigationController?.popViewControllerAnimated(true)
        } else {
            let alertDialog = UIAlertController(title: "Error", message: "No drink selected", preferredStyle: UIAlertControllerStyle.Alert)
            alertDialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alertDialog, animated: true, completion: nil)
        }
        
    }
    /**
    * The ok-button for the two pickeviews.
    */
    @IBAction func clickOK(sender: AnyObject) {
        if self.selector.alpha == 1.0 {
            stateChange(0)
        }
        if self.selectDate.alpha == 1.0 {
            stateChange(0)
        }
    }
    /**
    * Starts the Date-Time picker.
    */
    @IBAction func clickTime(sender: AnyObject) {
        if state == 0 {
            stateChange(3)
        }
    }
    /**
    * A new date is selected and saved.
    */
    @IBAction func selectDate(sender: AnyObject) {
        selTime = selectDate.date
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        tbTime.setTitle(dateFormatter.stringFromDate(selTime!), forState: UIControlState.Normal)

    }
    /**
    * The user wants to change the amount. The amount-pickerView is shown.
    */
    @IBAction func clickAmount(sender: AnyObject) {
        if state == 0 {
            selectorIs.removeAll(keepCapacity: false)
            selectorIs = amount
            
            selector.reloadAllComponents()
            mode = 2
            
            self.selector.selectRow(selAmount, inComponent: 0, animated: false)
            
            stateChange(2)
            
        } else {
            UIView.animateWithDuration(1.0) {
                self.selector.alpha = 0.0
            }
        }
    }
    /**
    * The user wants to change the percentage. The percantage-pickerview is shown.
    */
    @IBAction func clickPercent(sender: AnyObject) {
        
        if state == 0 {
            //var per : Float = 0.5
        
            selectorIs.removeAll(keepCapacity: false)
            selectorIs = percent
            
            selector.reloadAllComponents()
            
            mode = 1
            
            self.selector.selectRow(selPercent, inComponent: 0, animated: false)
            
            stateChange(1)
        } else {
            UIView.animateWithDuration(1.0) {
                self.selector.alpha = 0.0
            }
        }
        
        
    }
    
    /**
    * On loading all images and labels are added to the collectionView.
    * In edit-mode: The values of the editing-object are set.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editId == -1 {
            predefDrinks.append(Drink(_name: NSLocalizedString("newdrink", comment: "new drink"), _amount: 0.0, _percent: 0.0, _filename: "camera"))
        }
        
        drinkColl.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        var per : Float = 0.5
        for var i = 0; i < percent.count; i++ {
            percent[i] = per
            per += 0.5
        }
        
        count = predefDrinks.count
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let today = NSDate(timeIntervalSinceNow: 0)
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate:  today)
        
        
        let date = dateFormatter.dateFromString("\(components.year)-\(components.month)-\(components.day - 1) 00:00")
        selectDate.minimumDate = date
        
        let lastDate = dateFormatter.dateFromString("\(components.year)-\(components.month)-\(components.day) 23:59")
        
        selectDate.maximumDate = lastDate
        
        
        selector.transform = CGAffineTransformMakeTranslation(0, 250)
        veBlurBar.transform = CGAffineTransformMakeTranslation(0, 250)
        selector.alpha = 1.0
        selectDate.alpha = 1.0
        selectDate.transform = CGAffineTransformMakeTranslation(0, 250)
        //selectDate.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        //selector.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        btOK.alpha = 0.0
        
        if selDrinkId >= 0 {
            drinkColl.reloadData()
            tbPercent.setTitle("\(percent[selPercent]) %", forState: UIControlState.Normal)
            tbAmount.setTitle("\(amount[selAmount]) L", forState: UIControlState.Normal)
            if selDrinkSesction == 0 {
                selDrink = predefDrinks[selDrinkId].name
            } else {
                selDrink = appDelegate.userDrinks!.drinks[selDrinkId].name
            }
            self.navigationItem.title = String.localizedStringWithFormat(NSLocalizedString("editdrink", comment: "editdrink"), selDrink)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Done, target: self, action: "editDrinkComplete:")
            selectDate.date = selTime!
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            
            tbTime.setTitle(dateFormatter.stringFromDate(selTime!), forState: UIControlState.Normal)
        } else {
            selTime = NSDate(timeIntervalSinceNow: 0)
            selectDate(self)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func rotated() {
        if selDrinkId >= 0 {
            drinkColl.scrollToItemAtIndexPath(NSIndexPath(forItem: selDrinkId, inSection: selDrinkSesction), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        }
    }
    
    func editDrinkComplete(sender: UIBarButtonItem) {
        if selDrinkId >= 0 {
            var filename = ""
            if selDrinkSesction == 0 {
                selDrink = predefDrinks[selDrinkId].name
                filename = predefDrinks[selDrinkId].filename
            } else {
                selDrink = appDelegate.userDrinks!.drinks[selDrinkId].name
                filename = appDelegate.userDrinks!.drinks[selDrinkId].filename
            }
            if appDelegate.drinkManager == nil {
                appDelegate.drinkManager = DrinkManager()
            }
            appDelegate.drinkManager?.removeDrinkIndex(editId)
            
            let newDrink = Drink(_name: selDrink, _amount: amount[selAmount], _percent: percent[selPercent], _filename: filename)
            let alcoDrink = Alcodrink(_drink: newDrink, _drinkTime: selTime!)
            appDelegate.drinkManager?.addDrink(alcoDrink)
            appDelegate.drinkManager?.save()
            
            navigationController?.popViewControllerAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return predefDrinks.count
        } else if section == 1 {
            if appDelegate.userDrinks != nil {
                return appDelegate.userDrinks!.count()
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    /**
    * The data-source of the collectionView.
    * All elements consists of a ImageView and a Label.
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) 
        
        if indexPath.item == selDrinkId && indexPath.section == selDrinkSesction{
            cell.backgroundColor = UIColor.orangeColor()
        } else {
            cell.backgroundColor = UIColor.blackColor()
        }
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        if indexPath.section == 0 {
            var image = UIImageView(frame: CGRectMake(0, 5,cell.frame.width, cell.frame.height - 35))
            var textView = UILabel()
            if indexPath.item == predefDrinks.count - 1 && newImage != nil{
                image = UIImageView(frame: CGRectMake(5, 10,cell.frame.width - 10, cell.frame.height - 40))
                image.image = newImage!
                textView = UILabel(frame: CGRectMake(0, image.frame.height + 12.0,cell.frame.width, 30))
            } else {
                image.image = UIImage(named:predefDrinks[indexPath.row].filename)
                textView = UILabel(frame: CGRectMake(4, image.frame.height + 6.0,cell.frame.width - 8, 30))
            }
            
            //btPin0.layer.cornerRadius = _corner
            cell.layer.cornerRadius = image.frame.width / 4
            cell.addSubview(image)
            
            
            textView.text = predefDrinks[indexPath.row].name
            textView.numberOfLines = 2
            textView.textColor = UIColor.whiteColor()
            textView.textAlignment = .Center
            textView.font = UIFont.systemFontOfSize(12.0)
            cell.addSubview(textView)
        } else if indexPath.section == 1 {
            let elem = appDelegate.userDrinks!.drinks[indexPath.row]
            let image = UIImageView(frame: CGRectMake(5, 10,cell.frame.width - 10, cell.frame.height - 40))
            
            image.image = UIImage(contentsOfFile: elem.filename)
            
            //btPin0.layer.cornerRadius = _corner
            cell.layer.cornerRadius = image.frame.width / 4
            cell.addSubview(image)
            
            let textView = UILabel(frame: CGRectMake(0, image.frame.height + 12.0,cell.frame.width, 30))
            textView.numberOfLines = 1
            textView.text = elem.name
            textView.textColor = UIColor.whiteColor()
            textView.textAlignment = .Center
            textView.font = UIFont.systemFontOfSize(12.0)
            cell.addSubview(textView)
        }
        
        return cell
    }
    /**
    * The percentage has to be changed.
    * @param _select The percentage to show.
    */
    func selectPercent(_select: Float) {
        var elem = -1
        for var i = 0; i < percent.count && elem < 0; i++ {
            if percent[i] >= _select {
                elem = i
            }
        }
        selPercent = elem
    }
    /**
    * the amount has to be changed.
    * @param _amount The amout to show.
    */
    func selectAmount(_select: Float) {
        var elem = -1
        for var i = 0; i < amount.count && elem < 0; i++ {
            if amount[i] >= _select {
                elem = i
            }
        }
        selAmount = elem
    }
    /**
    * An element in the collection was selected.
    * The default-amounts are set.
    * The current selected element is marked.
    * (clicking on new drink): The ImagePicker is stared.
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        selDrinkId = indexPath.item
        selDrinkSesction = indexPath.section
        
        if lastSelection != nil && lastSelection?.item >= 0 && indexPath.item != lastSelection!.item{
            collectionView.reloadItemsAtIndexPaths([indexPath, lastSelection!])
        } else {
            collectionView.reloadItemsAtIndexPaths([indexPath])
        }
        lastSelection = indexPath
        
        if indexPath.section == 0 {
            let select = predefDrinks[indexPath.item]
            if indexPath.item < predefDrinks.count - 2 {
                    selectPercent(select.percent)
                    tbPercent.setTitle("\(percent[selPercent]) %", forState: UIControlState.Normal)
                    selectAmount(select.amount)
                    tbAmount.setTitle("\(amount[selAmount]) L", forState: UIControlState.Normal)
            } else {
                if indexPath.item == predefDrinks.count - 1 && editId == -1{
                    selectImage()
                }
            }
            selDrink = select.name
        } else {
            let select = appDelegate.userDrinks?.drinks[indexPath.item]
            selectPercent(select!.percent)
            tbPercent.setTitle("\(percent[selPercent]) %", forState: UIControlState.Normal)
            selectAmount(select!.amount)
            tbAmount.setTitle("\(amount[selAmount]) L", forState: UIControlState.Normal)
            selDrink = select!.name
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectorIs.count
    }
    
    /**
    * The dataMember for the pickerView.
    */
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //var attributedString: NSAttributedString!
        if mode == 1 {
            let attributedString = NSAttributedString(string: "\(selectorIs[row]) %", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            return attributedString
        } else {
            let attributedString = NSAttributedString(string: "\(selectorIs[row]) L", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
            return attributedString
        }
    }
    /**
    * The pickerView changed it's value. Based on the current state the field and variable is updated.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (mode == 1) {
            selPercent = row
            tbPercent.setTitle("\(selectorIs[row]) %", forState: .Normal)
        } else {
            selAmount = row
            tbAmount.setTitle("\(selectorIs[row]) L", forState: .Normal)
        }
    }
    /**
    * A new picture is selected.
    * The picture will be prepared for the app and shown.
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        newImage = image
        
        let ratio = CGFloat(newImage!.size.width) / CGFloat(newImage!.size.height)
        var size = CGRectMake(0, 0, 0, 0)
        if ratio > 1 {
            let yShift = 100/ratio/4
            size = CGRectMake(0, yShift, 100, 100 / ratio)
        } else {
            size = CGRectMake(0, 0, 100 * ratio, 100)
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(100, 100))
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,100, 100))
        newImage?.drawInRect(size)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.drinkColl.reloadItemsAtIndexPaths([NSIndexPath(forRow: count - 1, inSection: 0)])
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    /**
    * On cancelling nothing will be done.
    */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    /**
    * Starts the image-picker.
    */
    func startImageController(type : UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = type
        self.presentViewController(picker, animated: true, completion: nil)
    }
    /**
    * The user wants to create a new drink and selects the source image.
    */
    func selectImage() {
        let alertDelete = UIAlertController(title: NSLocalizedString("newdrink", comment: "new drink"), message: NSLocalizedString("selectpicsource", comment: "select picture source"), preferredStyle: UIAlertControllerStyle.ActionSheet)
        //if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            alertDelete.addAction(UIAlertAction(title:NSLocalizedString("camera", comment: "camera"),
                style: .Default, handler: { (action: UIAlertAction) in
                    self.startImageController(UIImagePickerControllerSourceType.Camera)
            }))
        }
        
        //newdrink="Neuer Drink";
        alertDelete.addAction(UIAlertAction(title: NSLocalizedString("photos", comment: "photos"), style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                self.startImageController(UIImagePickerControllerSourceType.PhotoLibrary)
        }))
        
        alertDelete.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alertDelete, animated: true, completion: nil)
    }
    /**
    * A new drink is saved to the storage.
    * @return The new drink as Drink-object.
    */
    func saveDrink() -> Drink {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        
        let today = NSDate(timeIntervalSinceNow: 0)
        let path = "\(UserDrinks.documentsDirectory())/\(dateFormatter.stringFromDate(today)).png"
        
        UIImagePNGRepresentation(newImage!)!.writeToFile(path, atomically: true)
        
        let newDrink = Drink(_name: NSLocalizedString("userdrink",comment: "userdrink"), _amount: amount[selAmount], _percent: percent[selPercent], _filename: path)
        appDelegate.userDrinks?.addDrink(newDrink)
        appDelegate.userDrinks?.save()
        
        return newDrink
    }
}
