//
//  FilterValue.swift
//  Filterer
//
//  Created by dede.exe on 11/13/15.
//  Copyright © 2015 UofT. All rights reserved.
//

import Foundation

public class FilterValue
{
    private var oldValue : Int
    private var currentValue : Int
    private var storedFilter : Filter
    
    public init (filter : Filter)
    {
        self.storedFilter = filter
        self.oldValue = 0
        self.currentValue = 0
        
        self.reset()
    }
    
    public var hasChanged : Bool {
        return self.oldValue != self.currentValue
    }
    
    public var value : Int
    {
        set {
            
            //Create the filter value and put the correct value... Not more than max and never lesse than minimal
            var filterValue = newValue
            filterValue = max(filterValue, storedFilter.minValue)
            filterValue = min(filterValue, storedFilter.maxValue)
            
            self.currentValue = filterValue
            self.filter.value = filterValue
        }
        
        get {
            return self.currentValue
        }
    }
    
    
    public var filter : Filter
    {
        return self.storedFilter
    }
    
    
    public var defaultValue : Int
    {
        return self.storedFilter.defaultValue
    }

    
    public var maxValue : Int
    {
        return self.storedFilter.maxValue
    }
    
    
    public var minValue : Int
    {
        return self.storedFilter.minValue
    }
    
    
    public func save() {
        self.oldValue = self.currentValue
    }
    
    
    public func cancel() {
        self.currentValue = self.oldValue
        self.filter.value = self.oldValue
    }
    
    
    public func reset()
    {
        oldValue = filter.defaultValue
        currentValue = filter.defaultValue
    }
    
}