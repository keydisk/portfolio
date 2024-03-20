//
//  SearchAPIs.swift
//  iOSTestProject
//
//  Created by JuYoung choi on 2/19/24.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON

/// 검색 API
class SearchAPIs {
    
    let api = APIClient()
    
    static let searchType = "type"
    
    /// 주소로 검색
    ///
    /// - Parameters:
    ///   - text: 주소
    ///   - pageNo: 페이지 번호
    ///   - size: 페이지 사이즈
    ///   - target: 검색 타겟
    ///   - sortingOption: 검색 옵션
    /// - Returns: 퍼블리셔
    public func requestBookList(text: String, target: SearchTarget, sortingOption: SortingType, pageNo: Int, size: Int) -> AnyPublisher<Data, NSError> {
        
        var parameter = Parameters()
        
        let header = [HTTPHeader(name: "Authorization", value: "KakaoAK 15208ecfaeedf448c41c9312cd133cd5")]
        
        parameter["query"]  = text
        parameter["page"]   = pageNo
        parameter["sort"]   = sortingOption.rawValue
        parameter["size"]   = size
        parameter["target"] = target.rawValue
        
        return self.api.requestData(url: "https://dapi.kakao.com/v3/search/book", param: parameter, header: header, method: .get).map({data -> Data in
                
            do {
                var json = JSON(data)
                json[SearchAPIs.searchType].string = target.rawValue
                
                return try json.rawData()
            } catch let error {
                
            }
            
            return data
        }).eraseToAnyPublisher()
    }
}
