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


/**
 A Manager of filter to apply on an image. 
 FilterManager instantiate insternally all filters and use it to change image properties.
*/
public class FilterManager
{
    
    //MARK: - Properties

    private var sourceImage : RGBAImage?
    
    private var workSourceImage : RGBAImage?
    private var workFilteredImage : RGBAImage?
    
    private var smallSizeWidth : Int
    private var smallSizeHeight : Int
    
    private var currentFilter : Filter?
    
    init(width:Int = 400, height:Int = 300)
    {
        self.smallSizeWidth = width
        self.smallSizeHeight = height
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

            let imageResizer = ImageAspectRationResizer(image: newValue!, width: self.smallSizeWidth , height: self.smallSizeHeight)
            
            if let renderedImage = imageResizer.renderedImage {
                self.workSourceImage = RGBAImage(image: renderedImage)
                self.workFilteredImage = self.workSourceImage
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

            if let filterItem = self.currentFilter
            {
                retImage = (RGBAImage(rgbaImage: retImage)?.filter(filterItem))!
            }

            return retImage.toUIImage()
        }
    }
    
    
    public var imageThumb : UIImage?
    {
        
        get
        {
            guard var retImage = self.workFilteredImage else
            {
                return nil
            }
            
            if let filterItem = self.currentFilter
            {
                retImage = (RGBAImage(rgbaImage: retImage)?.filter(filterItem))!
            }
            
            return retImage.toUIImage()
        }
        
    }
}
