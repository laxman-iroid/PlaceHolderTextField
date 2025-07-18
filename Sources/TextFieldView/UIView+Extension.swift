//
//  UIView+Extension.swift

//
//   Created by Vishal on 30/09/21.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: targetSize.width, height: targetSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
          if #available(iOS 11.0, *) {
              let cornerMasks = [
                  corners.contains(.topLeft) ? CACornerMask.layerMinXMinYCorner : nil,
                  corners.contains(.topRight) ? CACornerMask.layerMaxXMinYCorner : nil,
                  corners.contains(.bottomLeft) ? CACornerMask.layerMinXMaxYCorner : nil,
                  corners.contains(.bottomRight) ? CACornerMask.layerMaxXMaxYCorner : nil,
                  corners.contains(.allCorners) ? [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner] : nil
                  ].compactMap({ $0 })

              var maskedCorners: CACornerMask = []
              cornerMasks.forEach { (mask) in maskedCorners.insert(mask) }

              self.clipsToBounds = true
              self.layer.cornerRadius = radius
              self.layer.maskedCorners = maskedCorners
          } else {
              let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
              let mask = CAShapeLayer()
              mask.path = path.cgPath
              self.layer.mask = mask
          }
      }
    
    func makeBorderAndShadowToview(){
        self.backgroundColor = UIColor(white: 1, alpha: 1)
        self.layer.shadowColor = UIColor(white: 0.6, alpha: 1).cgColor
        self.layer.shadowOpacity = 0.9 // Defaults is 0 range 0-1 //for opacity of shadow dark or light
        self.layer.shadowRadius = 4 // Defaults is 3 // for blur radius
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5) //Defaults to (0, -3) // An offset of (2,2) will put the shadow 2 pixels to the right and 2 pixels down with respect to the element. These can also be negative values if you want the shadow to be to the top or left of the element.
        self.layer.borderColor = UIColor(red: 0.278, green: 0.725, blue: 0.886, alpha: 1.0).cgColor
    }
    
    
}
extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()

        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> String {

        guard let data = self.pngData() else {
            return ""
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }

        return String(format: "%.2f", size)
    }
}
public class NibView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadContentViewFromNib()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadContentViewFromNib()
    }
}

private extension NibView {
    func loadContentViewFromNib() {
        backgroundColor = UIColor.clear
        let contentView = loadNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}

extension UIView {
    /// Loads UIView from a XIB file with the same name.
    fileprivate func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -2), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
extension UIView{
    func animShow(){
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "position.y")
        self.isHidden = false
        // Set the animation's properties
        animation.fromValue = UIScreen.main.bounds.height
        animation.toValue = UIScreen.main.bounds.height - (self.bounds.height + 15)
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    func animHide(){
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "position.y")
        // Set the animation's properties
        animation.fromValue = UIScreen.main.bounds.height - self.bounds.height
        animation.toValue = UIScreen.main.bounds.height + self.bounds.height
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: nil)
        CATransaction.commit()
        CATransaction.setCompletionBlock { [weak self] in
            self?.isHidden = true
        }
    }
    
    func showHomeErrorView(){
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "position.y")
        self.isHidden = false
        // Set the animation's properties
        animation.fromValue = -200
        animation.toValue = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
        animation.duration = 0.8
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    func bounceView(){
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = self.center.y - 2
        animation.toValue = self.center.y + 2
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        // Add the animation to the view's layer.
        self.layer.add(animation, forKey: "bounce")
    }
}


extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension UIView {
    func addShadow(to edges: [UIRectEdge], radius: CGFloat = 3.0, opacity: Float = 0.6, color: CGColor = UIColor.black.cgColor) {

        let fromColor = color
        let toColor = UIColor.clear.cgColor
        let viewFrame = self.frame
        for edge in edges {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [fromColor, toColor]
            gradientLayer.opacity = opacity

            switch edge {
            case .top:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: radius)
            case .bottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
            case .left:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
            case .right:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
            default:
                break
            }
            self.layer.addSublayer(gradientLayer)
        }
    }

    func removeAllShadows() {
        if let sublayers = self.layer.sublayers, !sublayers.isEmpty {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
}
