//
//  PagingViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit



protocol PagingViewDelegate {
    func showPet()
}

var navBarHeight: CGFloat?
var pagingBarHeight: CGFloat?

class PagingViewController: UIViewController, CAPSPageMenuDelegate, PagingViewDelegate {

    var petListController: ListViewController?
    var currentPage = 1
    
    var pageMenu : CAPSPageMenu?

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
//        self.navigationController?.navigationBar.translucent = false
        
        navBarHeight = self.navigationController?.navigationBar.frame.size.height
        pagingBarHeight = CGFloat(35.0)
        
        // INITIATE PAGING MENU
        petListController = self.storyboard?.instantiateViewControllerWithIdentifier("PetsViewController") as? ListViewController
        petListController!.title = "pets"
        let feedController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
        feedController.title = "feed"
        
        petListController?.delegate = self
        
        let controllerArray = [feedController, petListController!]
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        
        var parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(netHex: 0x4C4C4F)),
            .ViewBackgroundColor(UIColor(netHex: 0xF7F7FF)),
            .SelectionIndicatorColor(UIColor.orangeColor()),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Light", size: 16.0)!),
            .MenuHeight(35.0),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorWidth(0.0),
            .AddBottomMenuHairline (false),
            .EnableHorizontalBounce(false),
//            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]
        

        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func willMoveToPage(controller: UIViewController, index: Int){}
    
    func didMoveToPage(controller: UIViewController, index: Int){
        if index == 1 {
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
        performSegueWithIdentifier("NewPetSegue", sender: self)
    }
    
    func showPet(){
        performSegueWithIdentifier("ShowPetSegue", sender: self)
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
