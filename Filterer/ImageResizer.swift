//
//  ImageResizer.swift
//  Filterer
//
//  Created by dede.exe on 11/13/15.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

public class ImageAspectRationResizer
{
    
    private var image : UIImage
    private var width : Int
    private var height : Int
    
    init (image:UIImage, width:Int, height:Int)
    {
        self.image = image
        self.height = height
        self.width = width
    }
    
    
    
    
    public var renderedImage : UIImage?
    {
        
        if let cgImage = image.CGImage
        {
            let width = CGImageGetWidth(cgImage)
            let height = CGImageGetHeight(cgImage)
            
            var newWidth = self.width
            var newHeight = self.height
            
            print("OLD W:\(width) H:\(height)")
            
            //Compare requested size is lesser than original size
            if self.width > width  && self.height > height {
                return image
            }
            
            //Calculate new sizes
            if self.width > self.height {
                newWidth =  (width * newHeight) / height
            } else {
                newHeight = (height * newWidth) / width
            }
            
            print("NEW W:\(newWidth) H:\(newHeight)")
            
            let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
            let bytesPerRow = CGImageGetBytesPerRow(cgImage)
            let colorSpace = CGImageGetColorSpace(cgImage)
            let bitmapInfo = CGImageGetBitmapInfo(cgImage)
            
            let context = CGBitmapContextCreate(nil, newWidth, newHeight, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
            
            CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
            CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight))), cgImage)
            
            if let retImage = CGBitmapContextCreateImage(context).flatMap({ UIImage(CGImage: $0) }) {
                return retImage
            }
            
            return nil
        }
        
        return nil
    }
    
}