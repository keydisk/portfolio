//
//  FontExtension.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI

extension Font {
    
    static func spoqaRegular(fontSize: CGFloat) -> Font {
        
        Font.custom("SpoqaHanSansNeo-Regular", fixedSize: fontSize)
    }
    
    static func spoqaBold(fontSize: CGFloat) -> Font {
        
        return Font.custom("SpoqaHanSansNeo-Bold", fixedSize: fontSize)
    }
    
    static func spoqaMedium(fontSize: CGFloat) -> Font {
        
        return Font.custom("SpoqaHanSansNeo-Medium", fixedSize: fontSize)
    }
    
    /// 기본 디폴트 폰트
    static var defaultFont: Font {
        
        Font.system(size: 15)
    }
}
