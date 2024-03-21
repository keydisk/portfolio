//
//  PageDataModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/19/24.
//

import Foundation

struct PageDataModel {
    
    static let pageSize: Int = 10
    
    /// 리스트 끝 여부
    var isEnd: Bool
    /// 페이징 가능한 카운트
    let pagableCnt: Int
    /// 전체 숫자
    var totalCnt: Int
    /// 현재 페이지
    var currentPageNo: Int = 1
    
}
