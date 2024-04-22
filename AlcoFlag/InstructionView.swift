//
//  InstructionView.swift
//  AlcoFlag
//
//  Created by Manuel Baumgartner on 01/05/2015.
//  Copyright (c) 2015 Hevselavier Lines Ver. All rights reserved.
//

import UIKit

/**
* The InstructionView is shown on first start to give a quick tutorial of the app.
*/
class InstructionView: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var svInstruct: UIScrollView!
    @IBOutlet weak var imInstruct: UIImageView!
    @IBOutlet weak var skipButton: UIBarButtonItem!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var imageName : String!
    var index : Int?
    var pageScroll = 0
    
    var language = 1
    /**
    * Loading the instruction-images in german.
    */
    let instructionGerman = ["alcoflag_start_german",
    "alcoflag_zero_german",
    "alcoflag_add_drink_german",
    "alcoflag_add_time_german",
    "alcoflag_add_percent_german",
    "alcoflag_add_amount_german",
    "alcoflag_add_picture_german",
    "alcoflag_44_german",
    "alcoflag_edit_german",
    "alcoflag_edit2_german",
    "alcoflag_edit3_german"]
    /**
    * Loading the instruction-images in english.
    */
    let instructionEnglish = ["alcoflag_start_english",
        "alcoflag_zero_english",
        "alcoflag_add_drink_english",
        "alcoflag_add_time_english",
        "alcoflag_add_percent_english",
        "alcoflag_add_amount_english",
        "alcoflag_add_picture_english",
        "alcoflag_44_english",
        "alcoflag_edit_english",
        "alcoflag_edit2_english",
        "alcoflag_edit3_english"]
    /**
    * Load the page-description already located.
    */
    var pageDescription = [
        NSLocalizedString("instruction1", comment: "Welcome to AlcoFlag"),
        NSLocalizedString("instruction2", comment: "Settings first"),
        NSLocalizedString("instruction3", comment: "notifications-set"),
        NSLocalizedString("instruction4", comment: "settings done"),
        NSLocalizedString("instruction5", comment: "collection of drinks"),
        NSLocalizedString("instruction6", comment: "drink time"),
        NSLocalizedString("instruction11", comment: "add picture"),
        NSLocalizedString("instruction7", comment: "alcohol-percent"),
        NSLocalizedString("instruction8", comment: "drink added"),
        NSLocalizedString("instruction9", comment: "remove drink"),
        NSLocalizedString("instruction10", comment: "drink removed")
    ]
    var pageViews: [UIView?] = []
    var transform = false
    /**
    * Go dynamically and animated to the next page. (pageButton)
    */
    @IBAction func gotoNext(sender: AnyObject) {
        var frame = svInstruct.frame;
        var currPage = pageControl.currentPage
        if(currPage + 1 < pageControl.numberOfPages) {
           currPage = pageControl.currentPage + 1
        } else {
            //skipInstruction(sender)
        }
        
        frame.origin.x = frame.size.width * CGFloat(currPage);
        frame.origin.y = 0;
        svInstruct.scrollRectToVisible(frame, animated: true)
    }
    /**
    * Goes to a particular page.
    */
    func gotoPage(page: Int, animated: Bool) {
        var frame = svInstruct.frame;
        
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        svInstruct.scrollRectToVisible(frame, animated: animated)
        
        if(page == 0) {
            backButton.enabled = false
        } else {
            backButton.enabled = true
        }
    }
    /**
    * Goes back to the previous page.
    */
    @IBAction func gotoBack(sender: AnyObject) {
        var frame = svInstruct.frame;
        var currPage = pageControl.currentPage
        if(currPage > 0) {
            currPage = pageControl.currentPage - 1
        }
        frame.origin.x = frame.size.width * CGFloat(currPage);
        frame.origin.y = 0;
        svInstruct.scrollRectToVisible(frame, animated: true)
    }
    /**
    * Loads the language of the system.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pre = NSLocale.preferredLanguages()[0] 
        if pre == "de" {
            language = 2
        } else {
            language = 1
        }
    }
    /**
    * On appearing new the current page is reloaded with the new size.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var pageImages = instructionEnglish
        if language == 2 {
            pageImages = instructionGerman
        }
        
        let pageCount = pageImages.count
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageImages.count
        
        // 4
        let pagesScrollViewSize = svInstruct.frame.size
        svInstruct.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
        
    }
    /**
    * Loads a particular page in the memory.
    */
    func loadPage(page: Int) {
        var pageImages = instructionEnglish
        if language == 2 {
            pageImages = instructionGerman
        }
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        // 1
        if pageViews[page] != nil {
        } else {
            // 2
            var frame = svInstruct.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            let newPageView = UIView(frame: frame)
            var imageView : UIImageView?
            var textView  : UITextView?
            if(UIDevice.currentDevice().orientation.isLandscape) {
                imageView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height - 40))
                imageView?.image = UIImage(named: pageImages[page])
                imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                textView = UITextView(frame: CGRectMake(0,frame.height - 40, frame.width, 40))
            } else {
                imageView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height - 75))
                imageView?.image = UIImage(named: pageImages[page])
                imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                textView = UITextView(frame: CGRectMake(0,frame.height - 75, frame.width, 75))
            }
            textView?.textColor = UIColor.whiteColor()
            textView?.backgroundColor = UIColor.blackColor()
            textView?.text = pageDescription[page]
            newPageView.addSubview(imageView!)
            newPageView.addSubview(textView!)
            svInstruct.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    /**
    * Removes a page from the memory.
    */
    func purgePage(page: Int) {
        var pageImages = instructionEnglish
        if language == 2 {
            pageImages = instructionGerman
        }
        if page < 0 || page >= pageImages.count {
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    /**
    * Loads all visible pages that are visible now and removes all that are not.
    */
    func loadVisiblePages() {
        var pageImages = instructionEnglish
        if language == 2 {
            pageImages = instructionGerman
        }
        // First, determine which page is currently visible
        let pageWidth = svInstruct.frame.size.width
        let page = Int(floor((svInstruct.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        pageControl.currentPage = page
        
        if page == 0 {
            backButton.enabled = false
        } else if page == pageControl.numberOfPages - 1 {
            nextButton.enabled = false
        } else {
            backButton.enabled = true
            nextButton.enabled = true
        }
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    /**
    * On scrolling the view is reloaded.
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        loadVisiblePages()
    }
    /**
    * Saves the current page before rotation change.
    */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        pageScroll = pageControl.currentPage
        transform = true
    }
    /**
    * Layouts all subviews on rotation change.
    */
    override func viewDidLayoutSubviews() {
        if transform  {
            var pageImages = instructionEnglish
            if language == 2 {
                pageImages = instructionGerman
            }
            
            for var index = 0; index < pageViews.count; ++index {
                purgePage(index)
            }
            
            for var index = 0; index < pageViews.count; ++index {
                loadPage(index)
            }
            
            let pagesScrollViewSize = svInstruct.frame.size
            svInstruct.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
                height: pagesScrollViewSize.height)
            transform = false
            //let pageWidth = svInstruct.frame.size.width
            svInstruct.contentOffset.x = 0
            
            gotoPage(pageScroll, animated: false)
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    * Closes the instruction menu.
    */
    @IBAction func skipInstruction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
