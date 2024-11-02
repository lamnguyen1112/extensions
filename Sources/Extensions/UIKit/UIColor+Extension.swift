//
//  UIColor+Extension.swift
//  Template
//
//  Created by Lam Nguyen on 4/24/22.
//

#if !os(macOS)
    import UIKit

    public extension UIColor {
        /**
         The six-digit hexadecimal representation of color of the form #RRGGBB.
         - parameter hex6: Six-digit hexadecimal value.
         */
        convenience init(hex hexValue: UInt32, alpha alph: CGFloat = 1.0) {
            let red = CGFloat((hexValue & 0xFF0000) >> 16) / CGFloat(255)
            let green = CGFloat((hexValue & 0x00FF00) >> 8) / CGFloat(255)
            let blue = CGFloat(hexValue & 0x0000FF) / CGFloat(255)
            self.init(red: red, green: green, blue: blue, alpha: alph)
        }

        convenience init(hexString: String) {
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let alphaColr: UInt64
            let redColr: UInt64
            let greenColr: UInt64
            let blueColr: UInt64

            switch hex.count {
            case 3: // RGB (12-bit)
                (alphaColr, redColr, greenColr, blueColr) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (alphaColr, redColr, greenColr, blueColr) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (alphaColr, redColr, greenColr, blueColr) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (alphaColr, redColr, greenColr, blueColr) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(redColr) / 255, green: CGFloat(greenColr) / 255, blue: CGFloat(blueColr) / 255, alpha: CGFloat(alphaColr) / 255)
        }

        func toImage(_ size: CGSize = CGSize(width: 8, height: 8)) -> UIImage? {
            if #available(iOS 10.0, *) {
                return UIGraphicsImageRenderer(size: size).image { rendererContext in
                    self.setFill()
                    rendererContext.fill(CGRect(origin: .zero, size: size))
                }
            } else {
                // Fallback on earlier versions
                let rect = CGRect(origin: CGPoint.zero, size: size)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                setFill()
                UIRectFill(rect)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image
            }
        }
    }

    public extension UIColor {
        static let defaultShadow = UIColor.black.withAlphaComponent(0.33)
    }
#endif
