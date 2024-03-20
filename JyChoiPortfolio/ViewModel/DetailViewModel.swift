//
//  DetailViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import Combine
import Foundation
import UIKit


/// 상세로 이동
class DetailViewModel: ObservableObject {
    
    @Published var url: String = "https://www.naver.com"
    
    func setClipboard(_ text: String) {
        
        UIPasteboard.general.string = text
        ToastMessage.shared.setMessage("\(text)가 클립보드에 복사 되었습니다.")
    }
}
