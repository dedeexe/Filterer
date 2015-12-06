import UIKit

/**
 Add Some Gray Scale to Image
 */
public class GrayFilter : Filter
{
    
    public required init(value: Int = 0) {
        
        var v : Int = value
        
        v = max(v, -128)
        v = min(v, 128)
        
        super.init(value: v)
    }
    
    public override var maxValue : Int { return 128 }
    public override var minValue : Int { return -128 }
    public override var defaultValue : Int { return 0 }
    
    public override func apply() -> RGBAImage? {
        
        guard let image = super.apply() else {
            return nil
        }
        
        let width = image.width
        let height = image.height
        
        let rgbaImage = RGBAImage(rgbaImage: image)
                
        for y in 0..<height {
            for x in 0..<width {
                
                let position = y * width + x
                var pixel = rgbaImage!.pixels[position]
                
                let red   = Int(pixel.red)
                let green = Int(pixel.green)
                let blue  = Int(pixel.blue)
                
                var result = (( red + green + blue ) / 3) + self.value
                result = min(255, max(0, result))
                
                pixel.red   = UInt8(result)
                pixel.green = UInt8(result)
                pixel.blue  = UInt8(result)
                
                image.pixels[position] = pixel
            }
        }
        
        return rgbaImage
        
    }
}


