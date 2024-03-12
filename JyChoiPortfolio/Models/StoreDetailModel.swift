//
//  StoreDetailModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import Foundation
import CoreLocation

struct StoreDetailModel {
    
    struct WifiInfo {
        let bandWidth: String
        let id: String
        let pw: String
    }
    
    struct StorageUnitInfo {
        let imgUrl: URL
        let description: String
    }
    
    let id: String
    let storeTitle: String
    let address: String
    
    let useGuide: String
    let parkingGuide: String
    let securityAndEntrance: String
    let wifiInfo: [WifiInfo]
    
    var printWifiInfo: String {
        
        var rtnText = ""
        
        self.wifiInfo.forEach({ model in
            rtnText = "\(model.bandWidth)\nID : \(model.id)\nPW : \(model.pw)\n"
        })
        
        return rtnText
    }
    
    let storageInfo: StorageUnitInfo
    
    let feature: String
    let navigationInfo: String
    let metroInfo: String
    let busInfo: String
    
    let faqList: [RefeatModel< (String, String)>]
    
    let loc: CLLocationCoordinate2D
}
