//
//  StoreModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import Foundation

/// 스토어 모델
struct StoreModel: Hashable, Identifiable {
    
    let id: String
    
    /// 지점 이미지 리스트
    let storeImgList: [ImgElement]
    /// 메타 데이터
    let metaData: StorePointModel
    /// 스토어 주소
    let address: String
    /// 스토어 테그
    let tagList: [TagModel<Bool>]
    /// 최저 금액
    let minimumPrice: Int
    var printMinimumPrice: String {
        
        self.minimumPrice.moneyString.appending("원")
    }
    
    /// 현 위치에서 거리
    var distance: Int
    var printDistance: String {
        
        String(format: "%.2fKm", Double(distance) / 1000)
    }
    
    static func == (lhs: StoreModel, rhs: StoreModel) -> Bool {
        
        lhs.metaData.id == rhs.metaData.id
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.metaData.id)
    }
    
}
