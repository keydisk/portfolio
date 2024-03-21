//
//  SortingType.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/20/24.
//

import Foundation

/// 정렬 타입
enum SortingType: String {
    
    case accuracy = "accuracy"
    case latest = "latest"
    
    var title: String {
        if self == .accuracy {
            "정확도순"
        } else {
            "최신순"
        }
    }
}
