import UIKit

/**
    Protocol to apply filters
*/
public protocol FilterProtocol
{
    
    var image : RGBAImage? {get set}
    var value : Int{ get set }
    
    var maxValue : Int { get }
    var minValue : Int { get }
    var defaultValue : Int { get }
    
    init(value:Int)
    func apply() -> RGBAImage?
}
