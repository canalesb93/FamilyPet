//
//  AddPetViewController.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/6/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit
import Parse


class AddPetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var petProfile: PFImageView!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var descriptionLabel: UITextField!
    @IBOutlet var segmentedControl: ADVSegmentedControl!
    
    @IBOutlet var ownersButton: UIButton!
    
    var imageAdded = false
    var petType = PetType.Dog
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        petProfile.layer.cornerRadius = petProfile.frame.size.width / 2;
        petProfile.clipsToBounds = true
        petProfile.layer.borderWidth = 6.0;
        petProfile.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        
        nameLabel.borderStyle = UITextBorderStyle.None
//        nameLabel.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        nameLabel.attributedPlaceholder = NSAttributedString(string:"name",
            attributes:[NSForegroundColorAttributeName: UIColor(netHex: 0xC8C8D2)])
        nameLabel.delegate = self
        
        descriptionLabel.borderStyle = .None
//        descriptionLabel.layer.borderColor = UIColor(netHex: 0x4C4C4F).CGColor
        descriptionLabel.attributedPlaceholder = NSAttributedString(string:"description, breed, sex",
            attributes:[NSForegroundColorAttributeName: UIColor(netHex: 0xC8C8D2)])
        descriptionLabel.delegate = self
        // Do any additional setup after loading the view.
        
        segmentedControl.items = ["dog", "cat", "other"]
        segmentedControl.selectedIndex = 0
        segmentedControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
        
        ownersButton.layer.borderWidth = 3
        ownersButton.layer.borderColor = UIColor(netHex: 0x74747B).CGColor
        
        //Looks for single or multiple taps.
//        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
//        view.addGestureRecognizer(tap)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        if selectedPet != nil {
            loadData()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        setOwnersButtonTitle()

    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func setOwnersButtonTitle(){
        if friendsSelected.count == 1 {
            ownersButton.setTitle("1 additional owner", forState: .Normal)
        } else if friendsSelected.count > 0 {
            ownersButton.setTitle("\(friendsSelected.count) additional owners", forState: .Normal)
        } else {
            ownersButton.setTitle("click to add owners", forState: .Normal)
        }

    }
    
    func loadData(){
        nameLabel.text = selectedPet?.name
        descriptionLabel.text = selectedPet?.attributes
        if let type = selectedPet?.type {
            segmentedControl.selectedIndex = type
        }
        petProfile.file = selectedPet?.image
        petProfile.loadInBackground()
        switch(selectedPet!.type){
        case 0:
            petType = PetType.Dog
        case 1:
            petType = PetType.Cat
        default:
            petType = PetType.Other
        }

        friendsSelected.removeAll(keepCapacity: false)
        
        var relation = selectedPet!.relationForKey("owners")
        // Find all owners
        relation.query()?.findObjectsInBackgroundWithBlock({ (oldOwners, error) -> Void in
            if error == nil {
                if let old = oldOwners as? [PFUser] {
                    for var i = 0; i < old.count; i++ {
                        if old[i].objectId != PFUser.currentUser()?.objectId {
                            friendsSelected.append(old[i])
                        }
                    }
                    self.setOwnersButtonTitle()
                }
            }
        })
        
        
    }
    
    func clearData(){
        nameLabel.text = ""
        descriptionLabel.text = ""
        segmentedControl.selectedIndex = 0
        petProfile.image = UIImage(named: "dogCamera")
        friendsSelected.removeAll(keepCapacity: false)
        setOwnersButtonTitle()
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // hide keyboard on enter
        self.view.endEditing(true)
        return false
    }
    
    
    func segmentValueChanged(sender: AnyObject?){
        if segmentedControl.selectedIndex == 0 {
            petType = .Dog
        }else if segmentedControl.selectedIndex == 1{
            petType = .Cat
        } else {
            petType = .Other
        }
    }
    
    @IBAction func ownersButton(sender: AnyObject) {
        let button = sender as! UIButton
        button.animateSlingPress()
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.showWaitOverlay()
        presentViewController(imagePicker, animated: true) { () -> Void in
            self.removeAllOverlays()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        var button = sender as! UIButton
        button.animateSlingPress()
        self.clearData()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        
        
    }
    
    @IBAction func save(sender: AnyObject) {
        
        let button = sender as! UIButton
        button.animateSlingPress()
        
        nameLabel.resignFirstResponder()
        
        //Disable the send button until we are ready
        // .enabled = false
        
        self.showWaitOverlay()
        if self.imageAdded {
            let pictureData = UIImageJPEGRepresentation(petProfile.image!, CGFloat(0.75))
            let file = PFFile(name: "image", data: pictureData)
            file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded {
                    //2
                    self.setPetRelations(file)
                } else if let error = error {
                    //3
                    println("Error \(error)")
                    //                self.showErrorView(error)
                }
                self.removeAllOverlays()
                
                }, progressBlock: { percent in
                    self.removeAllOverlays()
                    self.showWaitOverlayWithText("Uploaded: \(percent)%")
                    println("Uploaded: \(percent)%")
            })
        } else {
            setPetRelations(nil)
        }
        
    }

    
    func setPetRelations(newFile: PFFile?){
        
        
        // let’s say we have a few objects representing Author objects
        let owner = PFUser.currentUser()!
        var pet:Pet
        var relation:PFRelation
        if selectedPet != nil {
            pet = selectedPet!
            var relation = pet.relationForKey("owners")
            // Find all owners
            relation.query()?.findObjectsInBackgroundWithBlock({ (oldOwners, error) -> Void in
                if error == nil {
                    if let old = oldOwners as? [PFUser] {
                        for var i = 0; i < old.count; i++ {
                            if old[i].objectId != PFUser.currentUser()?.objectId {
                                relation.removeObject(old[i])
                            }
                        }
                        for var i = 0; i < friendsSelected.count; i++ {
                            relation.addObject(friendsSelected[i])
                        }
                        if self.imageAdded {
                            pet.image = newFile
                        }
                        pet.name = self.nameLabel.text
                        pet.type = self.petType.rawValue
                        pet.attributes = self.descriptionLabel.text
                        self.savePet(pet)
                    }
                }
            })
            
        } else {
            pet = Pet(image: newFile, user: PFUser.currentUser()!, name: self.nameLabel.text, type: self.petType, attributes: self.descriptionLabel.text)
            relation = pet.relationForKey("owners")
            relation.addObject(owner)
            for var i = 0; i < friendsSelected.count; i++ {
                relation.addObject(friendsSelected[i])
            }
            savePet(pet)
        }
        
    }
    
    func savePet(pet: Pet) {
        
        pet.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.clearData()
                NSNotificationCenter.defaultCenter().postNotificationName(reloadRequestNotificationKey, object: self)
                self.dismissViewControllerAnimated(true, completion: { () -> Void in })
                
            } else {
                //4
                if let errorMessage = error?.userInfo?["error"] as? String {
                    println("Error: \(error)")
                    //                    self.showErrorView(error!)
                }
            }
        }
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AddPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        petProfile.contentMode = UIViewContentMode.ScaleToFill
        let croppedImage: UIImage = ImageUtil.cropToSquare(image: image)
        petProfile.image = croppedImage
        imageAdded = true
        
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            UIApplication.sharedApplication().statusBarStyle = .LightContent
        })
        

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            UIApplication.sharedApplication().statusBarStyle = .LightContent
        })

    }
}