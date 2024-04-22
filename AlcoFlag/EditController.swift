//
//  EditController.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 25/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import UIKit

/**
* EditController is used for edit and delete drinks.
*/
class EditController: UITableViewController {

    @IBOutlet weak var deleteAllToolbar: UIToolbar!
    @IBOutlet weak var drinkTable: UITableView!
    var identifier = "drinkstable"
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var drinkManager : DrinkManager? = nil
    var selectionId = -1
    
    /**
    * Removes all drinks animated but before doing that the user is asked again.
    */
    @IBAction func removeAll(sender: AnyObject) {
        let alertDelete = UIAlertController(title: NSLocalizedString("deleteall", comment: "deleteall"), message: NSLocalizedString("deletealldrinks", comment: "deletealldrinks"), preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertDelete.addAction(UIAlertAction(title: NSLocalizedString("deleteall", comment: "deleteall"),
            style: .Destructive, handler: { (action: UIAlertAction) in
            var indexPaths = [NSIndexPath] (count: self.drinkManager!.drinks.count, repeatedValue: NSIndexPath())
            for var i = 0; i < indexPaths.count; i++ {
                indexPaths[i] = NSIndexPath(forRow: i, inSection: 0)
            }
            self.drinkTable.beginUpdates()
            self.drinkManager?.drinks.removeAll(keepCapacity: false)
            self.drinkTable.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            self.drinkTable.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.drinkTable.endUpdates()
            
            self.drinkManager?.save()
            
            self.fadeOutDeleteAll()
        }))
        
        alertDelete.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .Default, handler: nil))
        
        presentViewController(alertDelete, animated: true, completion: nil)
        
    }
    /**
    * The delete-all button fades out if there is no drink anymore in the list.
    */
    func fadeOutDeleteAll() {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.deleteAllToolbar.alpha = 0.0
        })
    }
    /**
    * Drinks are loaded from the DrinkManager.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        //drinkTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: identifier)
        self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let dm = appDelegate.drinkManager {
            drinkManager = dm
        } else {
            drinkManager = DrinkManager()
        }
        if drinkManager?.drinks.count == 0 {
            self.deleteAllToolbar.alpha = 0.0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.drinkTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if drinkManager!.drinks.count > 0 {
            return drinkManager!.drinks.count
        } else {
            return 1
        }
    }

    /**
    * The dataMember shows all informations about the drink.
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if drinkManager!.drinks.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("heracles", forIndexPath: indexPath) 
            cell.backgroundColor = UIColor.blackColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
            // Configure the cell...
            let drink = drinkManager!.drinks[indexPath.item].drink
            let date = drinkManager!.drinks[indexPath.item].drinkTime
            
            
            let drinkImage = cell.contentView.viewWithTag(10) as! UIImageView
            drinkImage.image = UIImage(named:drink.filename)
            
            let nameDrink = cell.contentView.viewWithTag(20) as! UILabel
            nameDrink.text = drink.name
            
            let timeDrink = cell.contentView.viewWithTag(30) as! UILabel
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let dateString = dateFormatter.stringFromDate(date)
            timeDrink.text = dateString
            
            let percentDrink = cell.contentView.viewWithTag(40) as! UILabel
            percentDrink.text = "\(drink.percent) %"
            
            let amountDrink = cell.contentView.viewWithTag(50) as! UILabel
            amountDrink.text = "\(drink.amount) L"
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.orangeColor()
            cell.selectedBackgroundView = bgColorView
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("nodrink", forIndexPath: indexPath) 
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if drinkManager!.drinks.count > 0 {
            selectionId = indexPath.item
            performSegueWithIdentifier("editDrink", sender: self)
        }
    }
    /**
    * Start the edit-mode and push a segue to the AddDrinkController.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "editDrink" {
            let editController = segue.destinationViewController as! AddDrinkController
            let selAlco = drinkManager?.drinks[selectionId]
            let select = selAlco?.drink
            editController.editMode(selectionId, selDrink: select!.name, _percent: select!.percent, _amount: select!.amount, _drinkTime: selAlco!.drinkTime)
        }
    }
    /**
    * Remove single drinks from the DrinkManager.
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete && drinkManager!.drinks.count > 0 {
            drinkManager?.removeDrinkIndex(indexPath.item)
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            drinkManager?.save()
            
            if drinkManager?.drinks.count == 0 {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
                fadeOutDeleteAll()
            } else {
                tableView.endUpdates()
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
