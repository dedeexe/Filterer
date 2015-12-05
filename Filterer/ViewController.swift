//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filterManager : FilterManager!
    
    var filteredImage: UIImage?
    var filteringImage: UIImage?
    
    var oldFilterValue : Int = 0
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var originalImageView : UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterValueView : UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var redFilterButton: UIButton!
    @IBOutlet var greenFilterButton: UIButton!
    @IBOutlet var blueFilterButton: UIButton!
    @IBOutlet var brightFilterButton: UIButton!
    
    
    @IBOutlet var slideFilterValue : UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.95)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        filterValueView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.95)
        filterValueView.translatesAutoresizingMaskIntoConstraints = false
        
        self.filterManager = FilterManager(width: Int(self.imageView.frame.width) , height: Int(self.imageView.frame.height))
    }

    
    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    // MARK: Main Events
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImageView.image = image
            imageView.image = image
            filterManager.image = image
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK:- Events
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }

    @IBAction func onFilterActivated(sender: UIButton) {
        
        var filterName:FilterType?
        
        switch sender
        {
            case self.brightFilterButton:
                filterName = FilterType.BRIGHTNESS
            default:
                filterName = nil
        }
        
    }
    
    @IBAction func onChangeFilterValue(sender:UISlider)
    {
        //TODO: Implements filter value change
        print("No filter selected")
    }
    
    //Cancel lasts changes
    @IBAction func onFilterChangesCancel(sender:UIButton)
    {
        self.imageView.image = self.filterManager.imageThumb
        hideFilterValueView()
    }

    //Confirm lasts changes
    @IBAction func onFilterChangesConfirm(sender:UIButton)
    {
        self.imageView.image = self.filterManager.imageThumb
        hideFilterValueView()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK: - SECONDARY MENU'S
    //-----------------------------------------------------------------------------------------
    
    // MARK: Hide and Show Secondary Menu
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu(animated : Bool = true) {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    //MARK: Hide and Show CompareView
    func showOriginalCompareImage()
    {
        
    }

    func hideOriginalCompareImage()
    {

    }
    
    
    //-----------------------------------------------------------------------------------------
    //MARK: - FILTER
    //-----------------------------------------------------------------------------------------

    //Show the View with values to configurate colors
    func showFilterValueView()
    {
        
        //Check if exist a filter to work
        //TODO: Put herer a filter validation
        
        view.insertSubview(filterValueView, aboveSubview: bottomMenu)
        
        let bottomConstraint = filterValueView.bottomAnchor.constraintEqualToAnchor(bottomMenu.bottomAnchor)
        let leftConstraint = filterValueView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = filterValueView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = filterValueView.heightAnchor.constraintEqualToConstant(88)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, heightConstraint, rightConstraint])
        
        view.layoutIfNeeded()
        
        self.filterValueView.alpha = 0
        
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 0.0
            self.bottomMenu.alpha = 0.0
            self.filterValueView.alpha = 1.0
        }
    }
    
    func hideFilterValueView() {
        UIView.animateWithDuration(0.4, animations: {
            self.filterValueView.alpha = 0.0
            self.secondaryMenu.alpha = 1.0
            self.bottomMenu.alpha = 1.0
            
            }) { completed in
                if completed == true {
                    self.filterValueView.removeFromSuperview()
                }
            }
    }
    
}