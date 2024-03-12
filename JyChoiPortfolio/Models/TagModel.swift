//
//  TagModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import Foundation

/// 테그 데이터
struct TagModel<T>: Hashable {
    /// 타이틀
    let title: String
    /// 테그 아이디
    let id: String
    /// 기타 데이터
    let metaData: T
    
    static func == (lhs: TagModel, rhs: TagModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.id)
    }
}
