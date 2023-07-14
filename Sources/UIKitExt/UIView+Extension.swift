//
//  UIView+Extension.swift
//  Template
//
//  Created by Lam Nguyen on 4/24/22.
//

#if !os(macOS)
import UIKit
import FoundationExt

// MARK: - Frame
public extension UIView {
    var xFrame: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    var yFrame: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    var top: CGFloat {
        get { return frame.origin.y }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }

    var bottom: CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var rect = frame
            rect.origin.y = newValue - rect.size.height
            frame = rect
        }
    }

    var left: CGFloat {
        get { return frame.origin.x }
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }

    var right: CGFloat {
        get { return frame.origin.x + frame.size.width }
        set {
            var rect = frame
            rect.origin.x = newValue - rect.size.width
            frame = rect
        }
    }
    
    var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
    var centerSelf: CGPoint { return CGPoint(x: width / 2.0, y: height / 2.0) }
}

public extension UIView {
    func rotate(degree: CGFloat = 0, duration: TimeInterval = 0) {
        runInMain { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.transform = CGAffineTransform(rotationAngle: CGFloat.pi * degree / 180.0)
            }
        }
    }
    
    func add(to superview: UIView, belowSubview: UIView? = nil, aboveSubview: UIView? = nil) {
        if let below = belowSubview {
            superview.insertSubview(self, belowSubview: below)
        } else if let above = aboveSubview {
            superview.insertSubview(self, aboveSubview: above)
        } else {
            superview.addSubview(self)
        }
    }

    func sizeThatFits(width: CGFloat = CGFloat.greatestFiniteMagnitude,
                      height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        sizeThatFits(CGSize(width: width, height: height))
    }
}

// MARK: - ViewController
public extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var parrentNavigationController: UINavigationController? {
        return parentViewController?.navigationController
    }
}

// MARK: - NIB
public extension UIView {
    class var nibNameClass: String? {
        return "\(self)".components(separatedBy: ".").first
    }

    class var nib: UINib? {
        guard Bundle.main.path(forResource: nibNameClass, ofType: "nib") != nil else { return nil }
        
        return UINib(nibName: nibNameClass ?? "", bundle: nil)
    }

    class func nib(bundle: Bundle = Bundle.main) -> UINib? {
        guard bundle.path(forResource: nibNameClass, ofType: "nib") != nil else { return nil }

        return UINib(nibName: nibNameClass ?? "", bundle: bundle)
    }

    class func fromNib(nibNameOrNil: String? = nil, inBundle: Bundle = Bundle.main) -> Self? {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self, inBundle: inBundle)
    }

    class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type, inBundle: Bundle = Bundle.main) -> T? {
        let nibName = (nibNameOrNil ?? nibNameClass) ?? ""
        guard inBundle.path(forResource: nibName, ofType: "nib") != nil else { return nil }

        guard let nibViews = inBundle.loadNibNamed(nibName, owner: nil, options: nil), nibViews.count > 0 else { return nil }

        for view in nibViews where view is T {
            return view as? T
        }
        return nil
    }
}

// MARK: - Layer
@IBDesignable
public extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get { return layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!) }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    @objc func setCornerRadius(_ radius: CGFloat, width: CGFloat = 0, color: UIColor? = nil) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
        if radius > 0 {
            clipsToBounds = true
        }
    }
    
    func roundCorner(with radius: CGFloat, isAddShadow: Bool = false) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        
        if isAddShadow {
            self.layer.addShadow()
        }
    }
}

// Mark: - Circle
public extension UIView {
    @IBInspectable var isCircle: Bool {
        get {
            return layer.cornerRadius == min(bounds.size.width, bounds.size.height)/2
        }
        set {
            if newValue {
                circle()
            }
        }
    }
}

protocol Circlable {
   func circle()
}

extension Circlable where Self: UIView {
   func circle() {
       layer.cornerRadius = min(bounds.size.width, bounds.size.height)/2
   }
}

extension UIView: Circlable {}

public extension UIView {
    enum Anchor {
        case left
        case top
        case right
        case bottom
    }

    @discardableResult
    func setLayout(_ attr1: NSLayoutConstraint.Attribute, is relation: NSLayoutConstraint.Relation = .equal, to: (view: Any, attribute: NSLayoutConstraint.Attribute)? = nil,
        multiplier: CGFloat = 1, constant: CGFloat = 0, activate: Bool = true) -> NSLayoutConstraint {
        let lc = NSLayoutConstraint(
            item: self, attribute: attr1, relatedBy: relation,
            toItem: to?.view, attribute: to?.attribute ?? .notAnAttribute,
            multiplier: multiplier, constant: constant
        )
        lc.isActive = activate
        return lc
    }

    @discardableResult
    @available(iOS 9.0, *)
    func constraint(equalToAnchorOf view: UIView,
                    safeArea: Bool = false,
                    top: CGFloat = 0,
                    left: CGFloat = 0,
                    bottom: CGFloat = 0,
                    right: CGFloat = 0) -> (top: NSLayoutConstraint, left: NSLayoutConstraint, bottom: NSLayoutConstraint, right: NSLayoutConstraint) {
        let topConst = topAnchor.constraint(equalTo: safeArea ? view.safeAreaTopAnchor : view.topAnchor, constant: top).activate()
        let leftConst = leftAnchor.constraint(equalTo: safeArea ? view.safeAreaLeftAnchor : view.leftAnchor, constant: left).activate()
        let bottomConst = bottomAnchor.constraint(equalTo: safeArea ? view.safeAreaBottomAnchor : view.bottomAnchor, constant: bottom).activate()
        let rightConst = rightAnchor.constraint(equalTo: safeArea ? view.safeAreaRightAnchor : view.rightAnchor, constant: right).activate()
        return (top: topConst, left: leftConst, bottom: bottomConst, right: rightConst)
    }
    
    /// Sets the left, right, top and bottom anchor, so the view fits it's container.
    /// - parameter container: The container for which this view will be a child of.
    /// - parameter anchors: The anchors that should be activated for the container.
    /// - parameter margins: The margins around view.
    func setFillingConstraints(in container: UIView,
                               anchors: [Anchor] = [.left, .top, .right, .bottom],
                               margins: UIEdgeInsets = UIEdgeInsets.zero) {
        translatesAutoresizingMaskIntoConstraints = false
        for anchor in anchors {
            switch anchor {
            case .left:
                leftAnchor.constraint(equalTo: container.leftAnchor, constant: margins.left).isActive = true
            case .top:
                topAnchor.constraint(equalTo: container.topAnchor, constant: margins.top).isActive = true
            case .right:
                rightAnchor.constraint(equalTo: container.rightAnchor, constant: margins.right).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: margins.bottom).isActive = true
            }
        }
        setNeedsUpdateConstraints()
    }

    func setFillingWithCenterAlign(in container: UIView, multiplier: CGFloat = 1.0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: multiplier).isActive = true
        heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: multiplier).isActive = true
    }

    func topAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func bottomAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func leftAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = leftAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func rightAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = rightAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func widthAnchor(to constant: CGFloat, priority: UILayoutPriority = .required) {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func heightAnchor(to constant: CGFloat, priority: UILayoutPriority = .required) {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func firstBaselineAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = firstBaselineAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func leadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func trailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = trailingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func centerXAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func centerYAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, priority: UILayoutPriority = .required) {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
    }

    func aspectRatioAnchor(to constant: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .width,
                                         multiplier: constant,
                                         constant: 0))
    }
}

public extension NSLayoutConstraint {
    @discardableResult
    func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}

// MARK: - SafeArea
@available(iOS 9.0, *)
public extension UIView {
    var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }

    var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }

    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }

    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }

    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }

    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }

    var safeAreaWidthAnchor: NSLayoutDimension {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.widthAnchor
        }
        return widthAnchor
    }

    var safeAreaHeightAnchor: NSLayoutDimension {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.heightAnchor
        }
        return heightAnchor
    }

    var safeAreaCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.centerXAnchor
        }
        return centerXAnchor
    }

    var safeAreaCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.centerYAnchor
        }
        return centerYAnchor
    }
}

public extension UIView {
    func setUserInteraction(_ isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
        for subview in subviews {
            subview.setUserInteraction(isEnabled)
        }
    }
}

// MARK: - Shadow
public extension UIView {
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor {
        get {
            let color = self.layer.shadowColor ?? UIColor.white.cgColor
            return UIColor(cgColor: color) // not using this property as such
        }
        set {
            self.layer.shadowColor = newValue.cgColor
            self.clipsToBounds = false
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    /// Apply shadow to the view
    /// - parameter radius: The blur radius (in points) used to render the layer’s shadow. Default value: 2
    /// - parameter opacity: The opacity of the layer’s shadow. Default value: 0.15
    /// - parameter offset: The offset (in points) of the layer’s shadow. Default value: CGSize(width: 0, height: 1)
    /// - parameter color: The color of the layer’s shadow. Default value: opaque black
    func applyShadow(radius: CGFloat = 2,
                     opacity: Float = 0.15,
                     offset: CGSize = CGSize(width: 0, height: 1),
                     color: UIColor = .defaultShadow) {
        let layer = self.layer
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }

    func applyShadow(_ shadow: NSShadow) {
        let layer = self.layer
        layer.shadowOffset = shadow.shadowOffset
        layer.shadowRadius = shadow.shadowBlurRadius

        guard let shadowColor = shadow.shadowColor as? UIColor else { return }

        layer.shadowOpacity = Float(shadowColor.cgColor.alpha)
        layer.shadowColor = shadowColor.cgColor
    }

    /// Draw lines between given points
    /// - parameter p0: The starting point for the line.
    /// - parameter p1: The end point for the line
    /// - parameter isDottedLine: Boolean value to decide whether its dotted or concreate line. default is true.
    /// - parameter strokeColor: The color of the layer’s strokecolor.
    func drawLineBetween(start p0: CGPoint,
                         end p1: CGPoint,
                         isDottedLine: Bool = true,
                         lineWidth: CGFloat? = nil,
                         strokeColor: CGColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor
        
        let w: CGFloat = lineWidth ?? (isDottedLine ? 2 : 4)
        shapeLayer.lineWidth = CGFloat(w)
        
        if isDottedLine {
            shapeLayer.lineDashPattern = [3, 2]
        }
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        let layer = self.layer
        layer.insertSublayer(shapeLayer, at: 0)
    }
}

public extension UIView {
    @discardableResult
    func addBlur(_ alpha: CGFloat = 1, style: UIBlurEffect.Style = .light) -> UIView {
            // create effect
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = alpha
        self.addSubview(blurEffectView)
        return blurEffectView
    }
}

// MARK: - To Image
public extension UIView {
    func captured(with scale: CGFloat = 0.0) -> UIImage? {
        var capturedImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: currentContext)
            capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        }

        UIGraphicsEndImageContext()
        return capturedImage
    }

    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

public extension UIView {
    func disableAutoLayout() {
        let frame = self.frame
        translatesAutoresizingMaskIntoConstraints = true
        self.frame = frame
    }
    
    func enableAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// Convenience way to add/remove multiple subviews at one time
public extension UIView {
    func addSubviews<S: Sequence>(_ subviews: S) where S.Iterator.Element: UIView {
        subviews.forEach(addSubview(_:))
    }
    
    func addSubviews(_ subviews: UIView...) {
        addSubviews(subviews)
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

#endif
