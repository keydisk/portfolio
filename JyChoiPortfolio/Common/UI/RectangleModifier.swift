//
//  RectangleModifier.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI

struct RectangleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content.shadow(color: Color(r: 80, g: 80, b: 80, a: 50), radius: 0, x: 5, y: 5)
    }
}
