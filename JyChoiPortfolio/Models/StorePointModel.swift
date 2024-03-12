//
//  StorePointModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import Foundation
import Combine
import CoreLocation

struct StorePointModel: Identifiable {
    
    typealias ID = String
    
    /// 지점 아이디
    let id: String
    /// 지점 이름
    let title: String
    /// 지점 위치
    let location: CLLocationCoordinate2D
    /// 지점 이미지 URL
    let thumbnailUrl: URL?
}
