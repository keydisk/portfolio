//
//  HorizontalTextModifier.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/19/24.
//

import SwiftUI

/// 텍스트 배치를 수월하게 하게 위해 사용
struct HorizontalTextModifier: ViewModifier {
    
    /// ture : 타이틀,  false : 컨텐츠
    let isTitle: Bool
    /// text 위치
    let align: Alignment
    /// 텍스트 컬러
    let textColor: Color
    /// 엣지
    let edges: (Edge.Set, CGFloat)
    
    init(isTitle: Bool, align: Alignment, textColor: Color = .black, edges: (Edge.Set, CGFloat)) {
        
        self.textColor = textColor
        self.isTitle = isTitle
        self.align = align
        self.edges = edges
    }
    
    func body(content: Content) -> some View {
        
        HStack(spacing: 0) {
            
            if align == .trailing || align == .center {
                Spacer()
            }
            
            content.foregroundColor(textColor).font(isTitle ? .spoqaBold(fontSize: 18) : .defaultFont)
            
            if align == .leading || align == .center {
                Spacer()
            }
        }.padding(edges.0, edges.1)
    }
}
