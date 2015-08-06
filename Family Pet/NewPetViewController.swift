//
//  NewPetViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse

class NewPetViewController: UIViewController {

    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var petProfile: UIImageView!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var descriptionLabel: UITextField!
    @IBOutlet var segmentedControl: ADVSegmentedControl!
    
    var imageAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        petProfile.layer.cornerRadius = petProfile.frame.size.width / 2;
        petProfile.clipsToBounds = true
        petProfile.layer.borderWidth = 3.0;
        petProfile.layer.borderColor = UIColor(netHex: 0xE0D59F).CGColor
        
        nameLabel.borderStyle = UITextBorderStyle.Line
        nameLabel.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        nameLabel.attributedPlaceholder = NSAttributedString(string:"placeholder text",
            attributes:[NSForegroundColorAttributeName: UIColor(netHex: 0xC8C8D2)])
        
        descriptionLabel.layer.borderWidth = 1.0
        descriptionLabel.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        descriptionLabel.attributedPlaceholder = NSAttributedString(string:"placeholder text",
            attributes:[NSForegroundColorAttributeName: UIColor(netHex: 0xC8C8D2)])
        // Do any additional setup after loading the view.
        
        segmentedControl.items = ["Dog", "Cat", "Other"]
        segmentedControl.selectedIndex = 1
        segmentedControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
    }
    
    @IBAction func save(sender: AnyObject) {
        
        nameLabel.resignFirstResponder()
        
        //Disable the send button until we are ready
        navigationItem.rightBarButtonItem?.enabled = false
        
        loadingSpinner.startAnimating()
        
        
        

        let pictureData = UIImageJPEGRepresentation(petProfile.image!, CGFloat(0.75))
        let file = PFFile(name: "image", data: pictureData)
        
        file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                //2
                self.savePet(file)
            } else if let error = error {
                //3
                println("Error \(error)")
//                self.showErrorView(error)
            }
            }, progressBlock: { percent in
                //4
                println("Uploaded: \(percent)%")
        })
        
    }
    
    func segmentValueChanged(sender: AnyObject?){
        println("Value changed")
        if segmentedControl.selectedIndex == 0 {
            
        }else if segmentedControl.selectedIndex == 1{
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savePet(file: PFFile?) {
        var newFile:PFFile?
        if imageAdded {
            newFile = file
        }
        
        // let’s say we have a few objects representing Author objects
        let ownerOne = PFUser.currentUser()!

        
        let pet = Pet(image: newFile, user: PFUser.currentUser()!, petName: self.nameLabel.text, petDescription: self.descriptionLabel.text)
        let relation = pet.relationForKey("owners")
        relation.addObject(ownerOne)
        
        pet.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.dismissViewControllerAnimated(true, completion: nil)
//                var next = self.storyboard?.instantiateViewControllerWithIdentifier("PetsViewController") as! PetsViewController
//                self.presentViewController(next, animated: true, completion: nil)
                
            } else {
                //4
                if let errorMessage = error?.userInfo?["error"] as? String {
                    println("Error: \(error)")
//                    self.showErrorView(error!)
                }
            }
        }
        
        
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

extension NewPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        petProfile.contentMode = UIViewContentMode.ScaleToFill
        petProfile.image = image
        imageAdded = true
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}