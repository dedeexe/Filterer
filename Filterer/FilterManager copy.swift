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
    case GREEN          = "Green"
    case RED            = "Red"
    case BLUE           = "Blue"
    case BRIGHTNESS     = "Brightness"
    
    static var collection : [FilterType.RawValue : FilterType] {
        
        let ret : [FilterType.RawValue : FilterType] = [
            FilterType.GREEN.rawValue : FilterType.GREEN,
            FilterType.RED.rawValue : FilterType.RED,
            FilterType.BLUE.rawValue : FilterType.BLUE,
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
    
    private var sourceImage : UIImage?
    private var filteredImage : UIImage?
    
    private var thumbSourceImage : UIImage?
    private var thumbFilteredImage : UIImage?
    
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
            guard let _ = newValue else
            {
                self.filteredImage = nil
                self.sourceImage = nil
                return
            }
            
            self.sourceImage = newValue!
            self.filteredImage = newValue!

            let imageResizer = ImageAspectRationResizer(image: newValue!, width: self.thumbSizeWidth , height: self.thumbSizeHeight)
            
            self.thumbSourceImage = imageResizer.renderedImage
            self.thumbFilteredImage = imageResizer.renderedImage
        }
        
        get
        {
            return self.sourceImage
        }
    }
    
    
    //Stored Attribute image after been processed
    public var imageWithFilter : UIImage?
    {
        get
        {
            guard var retImage = self.filteredImage else
            {
                return nil
            }

            for (_, filterItem) in self.filterList
            {
                retImage = (RGBAImage(image: retImage)?.filter(filterItem.filter)?.toUIImage())!
            }

            return retImage
        }
    }
    
    public var imageThumb : UIImage?
    {
        return self.thumbFilteredImage
    }
    
    private var filterList : [String:FilterValue] = [
        
        //Color Filters
        FilterType.GREEN.rawValue           : FilterValue(filter: BlueFilter()),
        FilterType.RED.rawValue             : FilterValue(filter: RedFilter()),
        FilterType.BLUE.rawValue            : FilterValue(filter: GreenFilter()),
        FilterType.BRIGHTNESS.rawValue      : FilterValue(filter: BrightnessFilter())
        
    ]
    
    //MARK: - Filter Functions
    public func filter(filterType : FilterType) -> FilterValue?
    {
        guard let fltr = self.filterList[filterType.rawValue] else
        {
            self.currentFilter = nil
            return nil
        }
        
        self.currentFilter = fltr
        return fltr
    }
    
    //Sintax Sugar
    public subscript(filterType : FilterType) -> FilterValue?
    {
        return filter(filterType)
    }
    
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
        
        do {
            try self.applyFilter()
        } catch {
            print("No image selectes")
            self.thumbFilteredImage = nil
        }
    }
    
    //Cancel all filters changes
    public func cancelChanges()
    {
        for (_, fltr) in filterList
        {
            fltr.cancel()
        }
        
        do {
            try self.applyFilter()
        } catch {
            print("No image selectes")
            self.thumbFilteredImage = nil
        }
    
    }
    
    
    //Apply all filters
    public func applyFilter() throws
    {
        
        guard var retImage = self.thumbSourceImage else
        {
            throw FilterControlError.NoImageLoaded
        }
        
        guard let filter = self.currentFilter else
        {
            throw FilterControlError.NoFilterSelected
        }

        retImage = (RGBAImage(image: retImage)?.filter(filter.filter)?.toUIImage())!

        thumbFilteredImage = retImage
        
    }
}
