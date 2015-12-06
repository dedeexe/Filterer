import UIKit

/**
Add Some Contrast to Image
*/
public class ContrastFilter : Filter
{
    
    public required init(value: Int = 0) {
        
        var v : Int = value
        
        v = max(v, -255)
        v = min(v, 255)
        
        super.init(value: v)
    }
    
    public override var maxValue : Int { return 255 }
    public override var minValue : Int { return -255 }
    public override var defaultValue : Int { return 0 }
    
    public override func apply() -> RGBAImage? {
        
        guard let image = super.apply() else {
            return nil
        }
        
        let width = image.width
        let height = image.height
        
        let rgbaImage = RGBAImage(rgbaImage: image)
        
        //Constrast Factor
        let factor = Double(259 * (self.value + 255)) / Double(255 * (259 - self.value))
                
        for y in 0..<height {
            for x in 0..<width {
                
                let position = y * width + x
                var pixel = rgbaImage!.pixels[position]
                
                var red   = factor * Double(Int(pixel.red) - 128) + 128
                var green = factor * Double(Int(pixel.green) - 128) + 128
                var blue  = factor * Double(Int(pixel.blue) - 128) + 128
                
                red   = min(255, max(0, red))
                green = min(255, max(0, green))
                blue  = min(255, max(0, blue))
                
                pixel.red   = UInt8(red)
                pixel.green = UInt8(green)
                pixel.blue  = UInt8(blue)
                
                image.pixels[position] = pixel
            }
        }
        
        return rgbaImage
        
    }
}


