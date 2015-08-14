//
//  PagingViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit


var navBarHeight: CGFloat?
var pagingBarHeight: CGFloat?

class PagingViewController: UIViewController, PagingMenuControllerDelegate {

    var petListController: ListViewController?
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //CONFIGURING NAVBAR
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(30)] as Dictionary!
        // userConfig.setTitleTextAttributes(attributes, forState: .Normal)
        // userConfig.tintColor = UIColor(netHex: 0x4C4C4F)
        // userConfig.title = String.fontAwesomeIconWithName(.Cog)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        navBarHeight = self.navigationController?.navigationBar.frame.size.height
        pagingBarHeight = CGFloat(35.0)
        
        // INITIATE PAGING MENU
        petListController = self.storyboard?.instantiateViewControllerWithIdentifier("PetsViewController") as? ListViewController
        petListController!.title = "pets"
        let feedController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
        feedController.title = "feed"
        let viewControllers = [feedController, petListController!]
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        let options = PagingMenuOptions()
        
        options.backgroundColor = UIColor(netHex:0x4C4C4F)
        options.selectedBackgroundColor = UIColor(netHex:0xF7F7FF)
        options.animationDuration = NSTimeInterval(0.25)
        
        options.selectedTextColor = UIColor(netHex: 0x4C4C4F)
        options.textColor = UIColor(netHex: 0xF7F7FF)
        options.font = UIFont(name: "HelveticaNeue-Light", size: 18)!


        options.menuItemMode = PagingMenuOptions.MenuItemMode.None
        options.menuHeight = pagingBarHeight!
        options.menuDisplayMode = PagingMenuOptions.MenuDisplayMode.FixedItemWidth(width: self.view.frame.width/2, centerItem: true, scrollingMode: .PagingEnabled)
        
        options.defaultPage = 0
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        pagingMenuController.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func willMoveToMenuPage(page: Int) {

    }
    
    func didMoveToMenuPage(page: Int) {
        if page == 1 {
            var b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newPet")
            self.navigationItem.rightBarButtonItem = b
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
    func newPet(){
        performSegueWithIdentifier("newPetSegue", sender: self)
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
