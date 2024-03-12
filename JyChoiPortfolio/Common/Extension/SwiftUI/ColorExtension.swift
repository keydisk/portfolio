//
//  ColorExtension.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB, red: Double((hex >> 16) & 0xff) / 255, green: Double((hex >> 08) & 0xff) / 255, blue: Double((hex >> 00) & 0xff) / 255, opacity: alpha )
    }
}

/// 컬러 설정
extension Color {
    
    init(r: Double, g: Double, b: Double, a: Double = 100) {
        
        self.init(red: r / 255, green: g / 255, blue: b / 255, opacity: a / 100)
    }
    
    /// 텍스트
    /// - Parameter rgbHex: rgb hex 값 ex:) #ffee11 or ffee11
    init(rgbHex: String, alpha: Double = 100) {
        
        let rgb = Scanner(string: rgbHex)
        _ = rgb.scanString("#")
        
        var rgbValue: UInt64 = 0
        rgb.scanHexInt64(&rgbValue)
        
        let r = Double( (rgbValue >> 16) & 0xff) / 255
        let g = Double( (rgbValue >> 8)  & 0xff) / 255
        let b = Double( (rgbValue >> 0)  & 0xff) / 255
        
        self.init(red: r, green: g, blue: b, opacity: alpha / 100)
    }
    
    static func rgba(r: Double, g: Double, b: Double, a: Double = 100) -> Color {
        
        Color(r: r, g: g, b: b, a: a)
    }
    
    static let lightGray = Color(r: 230, g: 230, b: 230)
}
