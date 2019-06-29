//
//  UtilsMacros.swift
//  Life
//
//  Created by tiens on 2019/6/12.
//  Copyright © 2019 yyy. All rights reserved.
//

import Foundation
import UIKit

/// main screen's scale
let kScreenScale = YYScreenScale()
/// main screen's size (portrait)
let kScreenSize = YYScreenSize()
/// main screen's width (portrait)
let kScreenWidth = YYScreenSize().width
/// main screen's height (portrait)
let kScreenHeight = YYScreenSize().height
/// 屏幕比例(字体适配)
let kScreenSZ = kScreenWidth/375.0
/// 底部安全区域的高度
public func kSafeAreaBottomSpace() -> CGFloat {
    var bottomSpace:CGFloat = 0
    if #available(iOS 11.0, *) {
        bottomSpace = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0
    }
    return bottomSpace
}
/// 状态栏的高度
public func kStatusBarHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}
/// 导航栏的高度(加状态栏)
public func kNavHeight() -> CGFloat {
    return (currentViewController().navigationController?.navigationBar.frame.size.height)! + kStatusBarHeight()
}
/// 常用对象window
public func keyWindow() -> UIWindow {
    let windows = UIApplication.shared.windows
    for window in windows.reversed() {
        if window.isKind(of: UIWindow.classForCoder()),window.bounds.equalTo(UIScreen.main.bounds) {
            return window
        }
    }
    return (UIApplication.shared.delegate!.window as? UIWindow)!
}
/// 列表页每页请求数据数量
let kLimit = isPad() ? 15 : 10
/// 是否是ipad
public func isPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
/// 平方-简-标准字体 和大小
public func FontPFRegularSize(_ fontPX:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFangSC-Regular", size: fontPX*kScreenSZ)!
}
/// 平方-简-中黑体 和大小
public func FontPFMediumSize(_ fontPX:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFangSC-Medium", size: fontPX*kScreenSZ)!
}
/// 确保主线程
public func dispatch_async_main_safe(block :@escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}
/// 当前控制器
public func currentViewController() -> UIViewController {
    
    var result: UIViewController?
    var window = UIApplication.shared.keyWindow

    if window?.windowLevel != UIWindow.Level.normal  {
        let windows = UIApplication.shared.windows
        for tmpWin in windows {
            if tmpWin.windowLevel == UIWindow.Level.normal {
                window = tmpWin
                break
            }
        }
    }
    
    result = window?.rootViewController
    
    while true {
        if (result?.presentedViewController != nil) {
            result = result?.presentedViewController!
        } else if result!.isKind(of: UITabBarController.classForCoder()) {
            let tabBar: UITabBarController = result as! UITabBarController
            result = tabBar.selectedViewController!
        } else if result!.isKind(of: UINavigationController.classForCoder()) {
            let nav: UINavigationController = result as! UINavigationController
            result = nav.visibleViewController!
        } else {
            break
        }
    }
    return result!
}
/// 边框位置
public enum CommonPosition {
    case top
    case left
    case bottom
    case right
    case center
}


