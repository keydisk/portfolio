//
//  RoundTextField.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI

/// 라운드 텍스트 필드
struct RoundTextField: View {
    
    @State var round: CGFloat
    @Binding var text: String
    /// iOS 15 부터 지원
//    var showKeyboard: FocusState<Bool>.Binding?
    @Binding var showKeyboard: Bool
    let placeHolder: String
    let edge: EdgeInsets
    
    /// 라운드 텍스트 필드
    /// - Parameters:
    ///   - round: 라운드 정도
    ///   - text: 텍스트 바인딩
    ///   - keyboardFocus: 원래는 포커싱 되어 있는지 여부
    ///   - placeHolder: 플레이스 홀더
    ///   - edge: 그려진 위치에서 얼마나 띄울지
    init(round: CGFloat, text: Binding<String>, keyboardFocus: Binding<Bool>, placeHolder: String, edge: EdgeInsets) {
        
        self._showKeyboard = keyboardFocus
        self.round = round
        self._text = text
        self.placeHolder = placeHolder
        self.edge = edge
    }
    
    var body: some View {
        // 라운드 랙트를 먼저 그리고 그 위에 overlay로 그리는 방법도 있지만 iOS15 이상 부터 지원이라 텍스트 필드를 먼저 그림
        TextField(self.placeHolder, text: $text).padding(self.edge).disableAutocorrection(true).frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10).stroke(Color.black)
            )
    }
}
