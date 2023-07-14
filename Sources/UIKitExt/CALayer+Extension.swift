
#if canImport(UIKit)
import UIKit

public extension CALayer {
    @discardableResult
    func defautShadow() -> CALayer {
        shadowOffset = .zero
        shadowOpacity = 0.1
        shadowRadius = 8
        shadowColor = UIColor.black.cgColor
        masksToBounds = false
        
        return self
    }
    
    @discardableResult
    func addShadow(offSet: CGSize = CGSize(width: 0, height: 2),
                   opacity: Float = 0.2,
                   radius: CGFloat = 3,
                   color: UIColor = UIColor.black) -> CALayer {
        shadowOffset = offSet
        shadowOpacity = opacity
        shadowRadius = radius
        shadowColor = color.cgColor
        masksToBounds = false
        
        return self
    }
    
    func removeShadow() {
        shadowOffset = .zero
        shadowOpacity = 0
        shadowRadius = 0
        shadowColor = UIColor.clear.cgColor
        masksToBounds = false
    }
    
    func applySketchShadow( color: UIColor = .black,
                            alpha: Float = 0.25,
                            xVal: CGFloat = 0,
                            yVal: CGFloat = 2,
                            blur: CGFloat = 2,
                            spread: CGFloat = 0,
                            cornerRdius: CGFloat = 8) {
        cornerRadius = cornerRdius
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xVal, height: yVal)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxValue = -spread
            let rect = bounds.insetBy(dx: dxValue, dy: dxValue)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
        }
    }
}
#endif
