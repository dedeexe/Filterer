import UIKit


/**
    Base Class filter
*/
public class Filter : FilterProtocol
{
    //MARK: Properties
    public var image : RGBAImage?

    ///If changed the value, set a flat as true
    public var value : Int = 0 

    public var maxValue : Int { return 100 }
    public var minValue : Int { return 0 }

    
    //MARK: Methods
    
    ///Initialize a filter with an initial value
    public required init(value: Int) {
        self.value = value
    }
    
    /**
        Apply the filter to the image

        :return: A new RGBAImage structure
    */
    public func apply() -> RGBAImage?
    {
        guard let rgbaImage = self.image else {
            return nil
        }
        
        guard let image = RGBAImage(rgbaImage: rgbaImage) else {
            return nil
        }
        
        return image
    }
    
    
    deinit
    {
        print("Terminated Filter")
    }
}