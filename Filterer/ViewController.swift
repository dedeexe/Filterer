//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {


    var filterManager : FilterManager!
    var filteredImage: UIImage?
    var filteringImage: UIImage?
    var currentFilter : Filter?
    var currentFilterStartValue : Int?
    
    var compareLongPress : UILongPressGestureRecognizer?
    
    var originalViewInserted : Bool = false
    
    @IBOutlet weak var workingView: UIView!
    @IBOutlet weak var originalView: UIView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var originalImageView : UIImageView!
    
    @IBOutlet weak var secondaryMenu: UIView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var filterValueView : UIView!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var brightFilterButton: UIButton!
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var slideFilterValue : UISlider!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.95)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        filterValueView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.95)
        filterValueView.translatesAutoresizingMaskIntoConstraints = false
        
        self.filterManager = FilterManager(width: Int(self.imageView.frame.width) , height: Int(self.imageView.frame.height))
        self.compareButton.enabled = false
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if !self.originalViewInserted
        {
            insertOriginalImageView()
            self.originalViewInserted = true
        }
    }
    
    
    //-----------------------------------------------------------------------------------------
    // MARK:- Events
    //-----------------------------------------------------------------------------------------
    
    //Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    // Main Events
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
    

    //Open Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }

    
    //When Activate a filter
    @IBAction func onFilterActivated(sender: UIButton) {
        
        switch sender
        {
            case self.brightFilterButton:
                self.currentFilter = filterManager.brigthnessFilter
            default:
                return
        }
        
        showFilterValueView()
        self.slideFilterValue.maximumValue = Float(self.currentFilter!.maxValue)
        self.slideFilterValue.minimumValue = Float(self.currentFilter!.minValue)
        self.slideFilterValue.value = Float(self.currentFilter!.value)
        self.currentFilterStartValue = self.currentFilter!.value
        
    }
    
    //Set a filter value
    @IBAction func onChangeFilterValue(sender:UISlider)
    {
        guard let filter = self.currentFilter else
        {
            NSLog("No present filter configurated")
            return
        }
        
        filter.value = Int(sender.value)
        self.imageView.image = self.filterManager.imageThumb
        
        if(!self.compareButton.enabled)
        {
            compareButton.enabled = true
        }
        
        if compareButton.selected {
            onCompare(compareButton)
        }
        
    }
    
    //Cancel lasts changes
    @IBAction func onFilterChangesCancel(sender:UIButton)
    {
        self.currentFilter!.value = self.currentFilterStartValue!
        self.imageView.image = self.filterManager.imageThumb
        hideFilterValueView()
        self.currentFilter = nil
    }

    //Confirm lasts changes
    @IBAction func onFilterChangesConfirm(sender:UIButton)
    {
        self.imageView.image = self.filterManager.imageThumb
        hideFilterValueView()
        self.currentFilter = nil
    }
    
    
    @IBAction func onCompare(sender:UIButton)
    {

        sender.selected = !sender.selected
        showOriginalImageView(sender.selected)
        
    }
    
    
    @IBAction func onCompareLongePress(longPress: UIGestureRecognizer)
    {
        if compareButton.enabled
        {
            if longPress.state == UIGestureRecognizerState.Began {
                self.compareButton.selected = true
                showOriginalImageView(true)
            }
            
            if longPress.state == UIGestureRecognizerState.Ended {
                self.compareButton.selected = false
                showOriginalImageView(false)
            }            
        }
    }
    
    
    //-----------------------------------------------------------------------------------------
    //MARK: - Select Photo
    //-----------------------------------------------------------------------------------------
    
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
            self.compareButton.enabled = false
            
            filterManager.image = image
            imageView.image = filterManager.imageThumb
            originalImageView.image = filterManager.imageThumb
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK: - Secondary Menu's
    //-----------------------------------------------------------------------------------------
    
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
    
    
    //-----------------------------------------------------------------------------------------
    //MARK: - Hide and Show CompareView
    //-----------------------------------------------------------------------------------------
    
    func insertOriginalImageView()
    {
        self.view.insertSubview(originalView!, belowSubview: workingView)
        self.originalView.frame = self.workingView.frame
        self.originalView.hidden = true
    }

    func removeOriginalImageView()
    {
        self.originalView.removeFromSuperview()
    }
    
    func showOriginalImageView(show : Bool)
    {
        if show {
            self.originalView.hidden = false
            
            UIView.animateWithDuration(0.4) { () -> Void in
                self.workingView.alpha = 0
            }
            
            return
        }
        
        UIView.animateWithDuration(0.4, animations: {
            self.workingView.alpha = 1.0
            }) { completed in
                if completed {
                    self.originalView.hidden = true
                }
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK: - Filters
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