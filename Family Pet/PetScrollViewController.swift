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
    @IBOutlet var contentView: UIView!
    
    // A strong reference to the width contraint of the contentView
    var contentViewConstraint: NSLayoutConstraint!
    
    var controllers = [UIViewController]()

    var bottomConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    // A computed version of this reference

    var computedContentViewConstraint: NSLayoutConstraint {
        return NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: .Height, multiplier: CGFloat(controllers.count + 1), constant: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScrollView()
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        scrollView.panGestureRecognizer.delaysTouchesBegan = true

        // Do any additional setup after loading the view.
    }
    
    func initScrollView(){
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentViewConstraint = computedContentViewConstraint
        view.addConstraint(contentViewConstraint)
        
        // Adding all the controllers you want in the scrollView
        let NewPetViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NewPetController") as! AddPetViewController
        let PetsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PetsListController") as! ListViewController
        
        addToScrollViewNewController(NewPetViewController)
        addToScrollViewNewController(PetsViewController)

        NewPetViewController.delegate = self
        PetsViewController.delegate = self
        
    }

    
    func addToScrollViewNewController(controller: UIViewController) {
        controller.willMoveToParentViewController(self)
        
        contentView.addSubview(controller.view)
        
        controller.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        
        heightConstraint = NSLayoutConstraint(item: controller.view, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0)
        
        leadingConstraint = NSLayoutConstraint(item: contentView, attribute: .Leading, relatedBy: .Equal, toItem: controller.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        trailingConstraint = NSLayoutConstraint(item: contentView, attribute: .Trailing, relatedBy: .Equal, toItem: controller.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        
//        topConstraint = NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: controller.view, attribute: .Top, multiplier: 1.0, constant: 0)

        
        // Setting all the constraints
        if controllers.isEmpty {
            // Since it's the first one, the trailing constraint is from the controller view to the contentView
            bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: controller.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        }
        else {
            bottomConstraint = NSLayoutConstraint(item: controllers.last!.view, attribute: .Top, relatedBy: .Equal, toItem: controller.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        }

        
        // Setting the new width constraint of the contentView
        view.removeConstraint(contentViewConstraint)
        contentViewConstraint = computedContentViewConstraint
        
        // Adding all the constraints to the view hierarchy
        view.addConstraint(contentViewConstraint)
        contentView.addConstraints([bottomConstraint, trailingConstraint, leadingConstraint])
        scrollView.addConstraints([heightConstraint])
        
        self.addChildViewController(controller)
        controller.didMoveToParentViewController(self)
        
        // Finally adding the controller in the list of controllers
        controllers.append(controller)
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
