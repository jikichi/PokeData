//
//  UIColor+Extension.swift
//  PokeData
//
//  Created by jikichi on 2021/02/28.
//

import Foundation
import UIKit.UIColor

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    static var mainBlue = UIColor.init(hex: "03A9F4")
    static var warning = UIColor.init(hex: "f44336")
    static var medium = UIColor.init(hex: "1CB7FF")
    static var row = UIColor.init(hex: "0173A8")
    
    static func customMainBlue(alpha: CGFloat) -> UIColor {
        return UIColor.init(hex: "03A9F4", alpha: alpha)
    }
}
