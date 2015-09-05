//
//  ColorPalette.swift
//  Pitch To Start Micro
//
//  Created by Cole Smith on 9/5/15.
//  Copyright (c) 2015 Cole Smith. All rights reserved.
//

import UIKit
   
let color_lightBlue = UIColor(r: 14, g: 113, b: 185, a: 255)

let color_darkBlue = UIColor(r: 10, g: 82, b: 134, a: 255)

let color_orange = UIColor(r: 228, g: 153, b: 60, a: 255)

extension UIColor {
    convenience init(r: Int, g:Int , b:Int , a: Int) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
}
