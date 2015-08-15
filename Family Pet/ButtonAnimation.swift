
//
//  ButtonAnimation.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/13/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

extension UIButton {
    func animateSlingPress(completion: () -> Void){
        let button = self
        button.transform = CGAffineTransformMakeScale(0.8, 0.8)
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: CGFloat(1.0), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            button.transform = CGAffineTransformIdentity
            }) { (success) -> Void in
                completion()
        }
    }
    
    func animateSlingPress(){
        let button = self
        button.transform = CGAffineTransformMakeScale(0.8, 0.8)
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: CGFloat(1.0), initialSpringVelocity: CGFloat(6.0), options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            button.transform = CGAffineTransformIdentity
            }) { (success) -> Void in
                
        }
    }
}