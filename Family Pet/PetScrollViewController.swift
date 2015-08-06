//
//  PetScrollViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

class PetScrollViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 1) Create the three views used in the swipe container view
        var PetsViewController = storyboard!.instantiateViewControllerWithIdentifier("PetsViewController") as! UIViewController
        var NewPetViewController = storyboard!.instantiateViewControllerWithIdentifier("NewPetViewController") as! UIViewController

//        var AVc :AViewController =  AViewController(nibName: "AViewController", bundle: nil);
//        var BVc :BViewController =  BViewController(nibName: "BViewController", bundle: nil);
//        var CVc :CViewController =  CViewController(nibName: "CViewController", bundle: nil);
        
        
        // 2) Add in each view to the container view hierarchy
        //    Add them in opposite order since the view hieracrhy is a stack
        
        self.addChildViewController(NewPetViewController);
        self.scrollView!.addSubview(NewPetViewController.view);
        NewPetViewController.didMoveToParentViewController(self);
        
        self.addChildViewController(PetsViewController);
        self.scrollView!.addSubview(PetsViewController.view);
        PetsViewController.didMoveToParentViewController(self);
        
        
        // 3) Set up the frames of the view controllers to align
        //    with eachother inside the container view
        var adminFrame :CGRect = PetsViewController.view.frame;
        adminFrame.origin.y = adminFrame.height - navBarHeight! - pagingBarHeight! - CGFloat(20.0)
        NewPetViewController.view.frame = adminFrame;
        
        

        // 4) Finally set the size of the scroll view that contains the frames
        var scrollWidth: CGFloat  = self.view.frame.width
        var scrollHeight: CGFloat  = 2 * (self.view.frame.size.height - navBarHeight! - pagingBarHeight! - CGFloat(20.0) )
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight);
        
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
