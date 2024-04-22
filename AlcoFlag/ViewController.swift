//
//  ViewController.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 11/03/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    @IBOutlet weak var imFlag: UIImageView!
    @IBOutlet weak var lbAlcohol: UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var drinkManager : DrinkManager? = nil
    var timer = NSTimer()
    var lastValue = 0.0
    var image : AnimatedImage?
    var instructionShown = false
    
    @IBOutlet weak var lbSober: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if appDelegate.drinkManager != nil {
            drinkManager = appDelegate.drinkManager
        } else {
            appDelegate.drinkManager = DrinkManager()
            drinkManager = appDelegate.drinkManager
        }
        image = AnimatedImage.animatedImageWithName("alcoflag_animation.gif")
        image?.setDuration(0.02)
        imFlag.setAnimatedImage(image!)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeApp:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeApp:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        //performSegueWithIdentifier("showInstruction", sender: self)
    }
    
    @objc func closeApp(notification: NSNotification) {
        timer.invalidate()
    }
    
    @objc func resumeApp(notification: NSNotification) {
        actualize()
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("actualize"), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.integerForKey("weight") == 0 {
            if instructionShown == false {
                instructionShown = true
                performSegueWithIdentifier("showInstruction", sender: self)
            }
            performSegueWithIdentifier("showSettings", sender: self)
        } else {
            actualize()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("actualize"), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer.invalidate()
    }
    
    func removeAllNotifications() {
         UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func prepareLocalNotifications(_fireDate : NSDate, _mode: Int) {
        let localNotification = UILocalNotification()
        if _mode == 3 {
            localNotification.alertBody = NSLocalizedString("reached05", comment: "Reached 0.5")
        } else if _mode == 4 {
            localNotification.alertBody = NSLocalizedString("reached08", comment: "Reached 0.8")
        } else {
            localNotification.alertBody = NSLocalizedString("reached00", comment: "youare sober")
        }
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber + 1
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.fireDate = _fireDate
        localNotification.category = "Alcoflag"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func actualize() {
        let bac = drinkManager?.calculateBAC()
        lbAlcohol.text = String(format: "%.2f ‰", bac!)
        
        removeAllNotifications()
        
        if bac > 0.0 {
            let soberAt = drinkManager?.calculateSoberAt(bac!)
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Day], fromDate: soberAt!)
            
            lbSober.text! =
                String.localizedStringWithFormat(NSLocalizedString("sober_at", comment: "soberattime"), components.hour, components.minute)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.integerForKey("notify") == 2 {
                prepareLocalNotifications(soberAt!, _mode: 2)
            } else if(defaults.integerForKey("notify") == 3) {
                if(bac > 0.5) {
                    let per50 = soberAt?.dateByAddingTimeInterval(-12000)
                    prepareLocalNotifications(per50!, _mode: 3)
                }
            } else if(defaults.integerForKey("notify") == 4) {
                if bac > 0.8 {
                    let per80 = soberAt?.dateByAddingTimeInterval(-19200)
                    prepareLocalNotifications(per80!, _mode: 3)
                }
            }
            
            var last = Int(lastValue * 100)
            if last > 149 {
                last = 149
            }
            var now = Int(bac! * 100)
            if now > 149 {
                now = 149
            }
            
            let diff = abs(last - now)
            var frameRate = 0.1
            if diff <= 10 {
                frameRate = 0.1
            } else if diff <= 20 {
                frameRate = 0.08
            } else if diff <= 40 {
                frameRate = 0.06
            } else if diff <= 80 {
                frameRate = 0.04
            } else {
                frameRate = 0.02
            }
            if diff > 0 {
                image?.setDuration(frameRate)
                imFlag.startAnimatingGIF(last, endValue: now)
                lastValue = Double(bac!)
            }
        } else {
            if lastValue > 0.0 {
                var last = Int(lastValue * 100)
                if last > 149 {
                    last = 149
                }
                image?.setDuration(0.02)
                imFlag.startAnimatingGIF(last, endValue: 0)
                
            }
            
            lastValue = 0.0
            timer.invalidate()
            lbSober.text! = NSLocalizedString("sober", comment: "sobertimeend")
        }
    }

    @IBAction func shareTwitter(sender: AnyObject) {
        let bac = drinkManager?.calculateBAC()
        let bacText = String(format: "%.2f ‰", bac!)
        var now = Int(bac! * 100)
        if now > 149 {
            now = 149
        }
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            var shareImage = image?.frameAtIndex(now)
            let size = CGRectMake(0, 0, 246, 320)
            
            UIGraphicsBeginImageContext(size.size)
            CGContextFillRect(UIGraphicsGetCurrentContext(), size)
            shareImage?.drawInRect(size)
            
            shareImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            twitterSheet.addImage(shareImage)
            if now < 10 {
                twitterSheet.setInitialText(NSLocalizedString("twittermessage1", comment: "no drinks today") + " (\(bacText)) #alcoflag")
            } else if now < 50 {
                twitterSheet.setInitialText(NSLocalizedString("twittermessage2", comment: "not much, drive") + " (\(bacText)) #alcoflag")
            } else if now < 100 {
                twitterSheet.setInitialText(NSLocalizedString("twittermessage3", comment: "grate party") + " (\(bacText)) #alcoflag")
            } else {
                twitterSheet.setInitialText(NSLocalizedString("twittermessage4", comment: "awesome") + " (\(bacText)) #alcoflag")
            }
            
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

