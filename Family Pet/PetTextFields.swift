//
//  PetTextFields.swift
//  PetsApp
//
//  Created by Ricardo Canales on 8/4/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import UIKit

class PetTextFields: UITextField {
    

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
    
    let padding = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 5);

    
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
