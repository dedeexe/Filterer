//
//  FilterControl.swift
//  Filterer
//
//  Created by dede.exe on 11/12/15.
//  Copyright © 2015 UofT. All rights reserved.
//


import UIKit

public enum FilterType : String
{
    case RGB            = "RGB"
    case BRIGHTNESS     = "Brightness"
    
    static var collection : [FilterType.RawValue : FilterType] {
        
        let ret : [FilterType.RawValue : FilterType] = [
            //FilterType.RGB.rawValue : FilterType.RGB,
            FilterType.BRIGHTNESS.rawValue : FilterType.BRIGHTNESS
        ]
        
        return ret
    }
}


public enum FilterControlError : ErrorType
{
    case NoImageLoaded
    case NoFilterSelected
}


public class FilterManager
{
    
    //-------------------------------------------------------------------------------
    //MARK: - Properties
    //-------------------------------------------------------------------------------

    private var sourceImage : RGBAImage?
    
    private var thumbSourceImage : RGBAImage?
    private var thumbFilteredImage : RGBAImage?
    
    private var currentFilter : FilterValue?
    
    private var thumbSizeWidth : Int
    private var thumbSizeHeight : Int
    
    init(width:Int = 400, height:Int = 300)
    {
        self.thumbSizeWidth = width
        self.thumbSizeHeight = height
    }
    
    
    //Stored Attribute image
    public var image : UIImage?
    {
        set
        {
            guard let newImage = newValue else
            {
                self.sourceImage = nil
                return
            }
            
            self.sourceImage = RGBAImage(image: newImage)

            let imageResizer = ImageAspectRationResizer(image: newValue!, width: self.thumbSizeWidth , height: self.thumbSizeHeight)
            
            
            if let renderedImage = imageResizer.renderedImage {
                self.thumbSourceImage = RGBAImage(image: renderedImage)
                self.thumbFilteredImage = self.thumbSourceImage
            }

        }
        
        get
        {
            return self.sourceImage?.toUIImage()
        }
    }
    
    
    //Stored Attribute image after been processed
    public var filteredImage : UIImage?
    {
        get
        {
            guard var retImage = self.sourceImage else
            {
                return nil
            }

            for (_, filterItem) in self.filterList
            {
                retImage = (RGBAImage(rgbaImage: retImage)?.filter(filterItem.filter))!
            }

            return retImage.toUIImage()
        }
    }
    
    
    public var imageThumb : UIImage?
    {
        
        get
        {
            guard var retImage = self.thumbFilteredImage else
            {
                return nil
            }
            
            for (_, filterItem) in self.filterList
            {
                retImage = (RGBAImage(rgbaImage: retImage)?.filter(filterItem.filter))!
            }
            
            return retImage.toUIImage()
        }
    }
    
    private var filterList : [FilterType : FilterValue] = [
        
        //Color Filters
        //FilterType.RGB              : FilterValue(filter: RGBFilter()),
        FilterType.BRIGHTNESS       : FilterValue(filter: BrightnessFilter())

    ]
    
    
    //Reset all filters
    public func reset()
    {
        for (_, fltr) in filterList
        {
            fltr.reset()
        }
    }
    
    //Save all filters
    public func saveChanges()
    {
        for (_, fltr) in filterList
        {
            fltr.save()
        }
    }
    
    
    //Cancel all filters changes
    public func cancelChanges()
    {
        for (_, fltr) in filterList
        {
            fltr.cancel()
        }
    }
    
    
    //-------------------------------------------------------------------------------
    //MARK: - Filter Settings
    //-------------------------------------------------------------------------------
    
    public var brightness : Int {
        
        set {
            guard let filter = filterList[FilterType.BRIGHTNESS] else { return }
            
            var value = max(-255, newValue)
            value = min(value, 255)
            
            filter.value = newValue
        }
        
        get{
            guard let filter = filterList[FilterType.BRIGHTNESS] else { return 0 }
            
            return filter.value
        }
    }
    
    
    
}
