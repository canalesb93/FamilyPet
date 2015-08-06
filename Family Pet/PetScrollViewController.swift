//
//  PetScrollViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

// Declare this protocol outside the class
protocol PetScrollView {
    // This method allows a child to tell the parent view controller
    // to change to a different child view
    func moveToView(viewNum: Int)
}

class PetScrollViewController: UIViewController, PetScrollView {

    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 1) Create the three views used in the swipe container view
        var PetsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PetsListController") as! ListViewController
        var NewPetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NewPetController") as! AddPetViewController

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
        
        PetsViewController.delegate = self
        NewPetViewController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /// Make sure you add this method to conform to the protocol
    func moveToView(viewNum: Int) {
        // Determine the offset in the scroll view we need to move to
        var yPos: CGFloat = self.view.frame.height * CGFloat(viewNum)
        self.scrollView.setContentOffset(CGPointMake(0,yPos), animated: true)
    }

}
