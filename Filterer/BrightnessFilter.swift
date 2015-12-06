import UIKit

/**
    Bright filter
*/
public class BrightnessFilter : Filter
{
    
    public required init(value: Int = 0) {
        
        var v : Int = value
        
        v = max(v, -255)
        v = min(v, 255)
        
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
        
        dump(rgbaImage)
        print("-----")
        dump(image)
        
        print(width, height)
        
        for y in 0..<height {
            for x in 0..<width {
                
                let position = y * width + x
                var pixel = rgbaImage!.pixels[position]
                
                var red   = Int(pixel.red) + self.value
                var green = Int(pixel.green) + self.value
                var blue  = Int(pixel.blue) + self.value
                
                //red   = (red > 255)   ? 255 : (red < 0)   ? 0 : red
                //green = (green > 255) ? 255 : (green < 0) ? 0 : green
                //blue  = (blue > 255)  ? 255 : (blue < 0)  ? 0 : blue

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

