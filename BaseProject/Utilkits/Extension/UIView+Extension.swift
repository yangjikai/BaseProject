//
//  Extension-UIView.swift
//  Life
//
//  Created by 杨冀凯 on 2019/6/12.
//  Copyright © 2019 yyy. All rights reserved.
//

extension UIView {
    
    /// 给view添加边框
    ///
    /// - Parameters:
    ///   - position: 边框位置
    ///   - inset: 内边距，默认zero
    ///   - color: 颜色
    ///   - width: 边框宽度
    public func addBorder(position: CommonPosition, inset: UIEdgeInsets? = nil, color: UIColor, width: CGFloat) {
        
        let scaleWidth = width
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        if inset != nil {
            switch position {
            case .top:
                border.frame = CGRect(x: inset!.left, y: 0, width: self.bounds.size.width - abs(inset!.left) - abs(inset!.right), height: scaleWidth)
            case .left:
                border.frame = CGRect(x: 0, y: inset!.top, width: scaleWidth, height: self.bounds.size.height - abs(inset!.top) - abs(inset!.bottom))
            case .bottom:
                border.frame = CGRect(x: inset!.left, y: self.bounds.size.height - scaleWidth, width: self.bounds.size.width - abs(inset!.left) - abs(inset!.right), height: scaleWidth)
            case .right:
                border.frame = CGRect(x: self.bounds.size.width - scaleWidth, y: inset!.top, width: scaleWidth, height: self.bounds.size.height - abs(inset!.top) - abs(inset!.bottom))
            case .center: break
                
            }
        } else {
            switch position {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: scaleWidth)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: scaleWidth, height: self.bounds.size.height)
            case .bottom:
                border.frame = CGRect(x: 0, y: self.bounds.size.height - scaleWidth, width: self.bounds.size.width, height: scaleWidth)
            case .right:
                border.frame = CGRect(x: self.bounds.size.width - scaleWidth, y: 0, width: scaleWidth, height: self.bounds.size.height)
            case .center: break
            }
        }
        self.layer.addSublayer(border)
    }
    
    /// 切圆角
    ///
    /// - Parameter cornerRadius: 圆角半径
    func roundedCorners(cornerRadius: CGFloat) {
        roundedCorners(cornerRadius: cornerRadius, borderWidth: 0, borderColor: nil)
    }
    
    /// 圆角边框设置
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - borderWidth: 边款宽度
    ///   - borderColor: 边款颜色
    func roundedCorners(cornerRadius: CGFloat?, borderWidth: CGFloat?, borderColor: UIColor?) {
        self.layer.cornerRadius = cornerRadius!
        self.layer.borderWidth = borderWidth!
        self.layer.borderColor = borderColor?.cgColor
        self.layer.masksToBounds = true
    }
    
    /// 设置指定角的圆角
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角半径
    ///   - rectCorner: 指定切圆角的角
    func roundedCorners(cornerRadius: CGFloat?, rectCorner: UIRectCorner?) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner!, cornerRadii: CGSize(width: cornerRadius!, height: cornerRadius!))
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path.cgPath
        self.layer.mask = layer
    }
    
    /// 渐变色
    ///
    /// - Parameters:
    ///   - colors: 渐变的颜色
    ///   - locations: 每个颜色所在的位置(0为开始位...1为结束位)
    ///   - startPoint: 开始坐标[0...1]
    ///   - endPoint: 结束坐标[0...1]
    func gradientColor(colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        /*
         表示竖向渐变
         gradientLayer.startPoint = CGPoint(x: 0, y: 0)
         gradientLayer.endPoint = CGPoint(x: 0, y: 1)
         */
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// view 添加模糊效果
    ///
    /// - Parameter style: UIBlurEffectStyle
    func addBlurEffect(style: UIBlurEffect.Style) {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = self.bounds
        self.backgroundColor = .clear
        self.addSubview(effectView)
        self.sendSubviewToBack(effectView)
    }
}

