import UIKit

/**
    Add or remove blue color filter
*/
public class RGBFilter : Filter
{
    var valueRed    : Int
    var valueGreen  : Int
    var valueBlue   : Int
    
    public required init(valueRed: Int = 100, valueGreen: Int = 100, valueBlue: Int = 100) {
        
        self.valueRed   = min(100, max(0, valueRed))
        self.valueGreen = min(100, max(0, valueGreen))
        self.valueBlue  = min(100, max(0, valueBlue))
        
        super.init(value: 0)
    }

    public override var isActivated : Bool {
        return self.defaultValue != self.valueRed ||
                self.defaultValue != self.valueGreen ||
                self.defaultValue != self.valueBlue
    }

    
    public required init(value: Int) {
        fatalError("init(value:) has not been implemented")
    }
    
    
    public override var defaultValue : Int {
        return 100
    }
    
    public override func apply() -> RGBAImage? {
        
        guard let image = super.apply() else {
            return nil
        }
        
        //Just process the image if filter is activated
        if self.isActivated
        {
            
            let width = image.width
            let height = image.height
            
            for y in 0..<height {
                for x in 0..<width {
                    let position = y * width + x
                    var pixel = image.pixels[position]
                    
                    pixel.blue = UInt8( Int(pixel.blue) * self.valueBlue / 100 )
                    pixel.red = UInt8( Int(pixel.blue) * self.valueRed / 100 )
                    pixel.green = UInt8( Int(pixel.blue) * self.valueGreen / 100 )
                    
                    image.pixels[position] = pixel
                }
            }
        }
        
        return image
        
    }
    
}

