//
//  PetDescription.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

class PetDescriptionTextField: UITextField {
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        setupView()
    //    }
    //
    //    required init(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        setupView()
    //    }
    //
    //
    //    func setupView() {
    //        borderStyle = UITextBorderStyle.None
    //        backgroundColor = UIColor.clearColor()
    //
    //    }
    
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 5);
    
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }
    
    
}