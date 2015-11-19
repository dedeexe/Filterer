import UIKit

/**
Add Some Contrast to Image
*/
public class ContrastFilter : Filter
{
    
    public required init(value: Int) {
        
        var v : Int = value
        
        if v > 255 { v = 255 }
        else if v < -255 { v = -255 }
        
        super.init(value: v)
    }
    
    public override func apply() -> RGBAImage? {
        
        guard let image = super.apply() else {
            return nil
        }
        
        
        if self.isActivated
        {
            let factor = (259 * (self.value + 255 )) / (255 * ( 259 - self.value ))
            
            let width = image.width
            let height = image.height

            for y in 0..<height {
                for x in 0..<width {
                    
                    let position = y * width + x
                    var pixel = image.pixels[position]
                    
                    var red   = factor * (Int(pixel.red) - 128) + 128
                    var green = factor * (Int(pixel.green) - 128) + 128
                    var blue  = factor * (Int(pixel.blue) - 128) + 128
                    
                    red   = (red > 255)   ? 255 : (red < 0)   ? 0 : red
                    green = (green > 255) ? 255 : (green < 0) ? 0 : green
                    blue  = (blue > 255)  ? 255 : (blue < 0)  ? 0 : blue

                    pixel.red   = UInt8(red)
                    pixel.green = UInt8(green)
                    pixel.blue  = UInt8(blue)
                    
                    image.pixels[position] = pixel
                }
            }
        }

        
        return image
        
    }
}

