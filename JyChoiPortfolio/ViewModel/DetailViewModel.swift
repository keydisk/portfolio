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
    
    /// 지점 상세 모델
    enum StoreLocationFeatureModel<T> {
        
        case address(T, T)
        case feature(T, T)
        case navigation(T, T)
        case metro(T, T)
        case bus(T, T)
        
    }
    
    @Published var url: String = "https://www.naver.com"
    var model: StoreDetailModel!
    
    var storeLocationFeature: [RefeatModel<StoreLocationFeatureModel<String>>] = []
    
    func setData(_ model: StoreModel) {
        
        self.model = StoreDetailModel(id: model.id, storeTitle: model.metaData.title, address: model.address, useGuide: "매일 24시간 운영됩니다.", parkingGuide: "건물 후면 지상 주차장에 주차 가능하며, 1시간 무료 주차 지원 합니다.", securityAndEntrance: ".[이용하기] 신청 후 이용 시작일부터 혹은 [즉시 방문] 신청 후 1시간 동안 지점 출입이 가능합니다.", wifiInfo: [StoreDetailModel.WifiInfo(bandWidth: "2.4G", id: "dalock", pw: "dalockP"), StoreDetailModel.WifiInfo(bandWidth: "5G", id: "dalock", pw: "dalockP")], storageInfo: StoreDetailModel.StorageUnitInfo(imgUrl: URL(string: "https://gaguclub.co.kr/web/product/big/202106/32c00bf64ca6736c4a07af409300cfe1.jpg")!, description: "계절옷 넣는데 최적화된 사이즈"), feature: "", navigationInfo: "검색창 또는 내비게이션에 '올림픽공원점'이나 '백제 고분로 505' 검색", metroInfo: "한성백제역 1번출구", busInfo: "333, 340", faqList: [RefeatModel(id: "1", metaData: ("1. 카트나 사디리가 있나요?", "물품 보관을 위한 카트 및 사다리가 구비 되어 있습니다.") ), RefeatModel(id: "2", metaData: ("2. 카트나 사디리가 있나요?", "22 물품 보관을 위한 카트 및 사다리가 구비 되어 있습니다.") )], loc: model.metaData.location )

        
        self.storeLocationFeature = [RefeatModel(id: "1", metaData: .address("주소", self.model.address)), RefeatModel(id: "2", metaData: .address("네비게이션", self.model.navigationInfo)), RefeatModel(id: "3", metaData: .metro("지하철", self.model.metroInfo)), RefeatModel(id: "4", metaData: .address("버스", self.model.busInfo))]
    }
    
    var shareAddress: String {
        self.model.address
    }
    
    /// 선택된 아이콘타입에서 정보 조회
    func storeInfo(_ type: IconType) -> String {
        
        switch type {
        case .useGuide:
            return self.model.useGuide
        case .parking:
            return self.model.parkingGuide
        case .secureAndEnter:
            return self.model.securityAndEntrance
        case .wifiInfo:
            return self.model.printWifiInfo
        }
    }
    
    func setClipboard(_ text: String) {
        
        UIPasteboard.general.string = text
        ToastMessage.shared.setMessage("\(text)가 클립보드에 복사 되었습니다.")
    }
}
