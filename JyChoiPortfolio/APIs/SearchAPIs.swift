//
//  SearchAPIs.swift
//  iOSTestProject
//
//  Created by JuYoung choi on 2/19/24.
//

import Foundation
import Combine
import Alamofire

/// 검색 API
class SearchAPIs {
    
    let api = APIClient()
    
    private func getParamer(_ keyword: String, _ pageNo: Int) -> Parameters {
        
        var param = Parameters()
        
        param["q"] = keyword
        param["page"] = pageNo
        
        return param
    }
    
    /// 주소로 검색
    ///
    /// - Parameters:
    ///   - text: 주소
    ///   - pageNo: 페이지 번호
    ///   - size: 페이지 사이즈
    public func requestAddressFromAddress(text: String, pageNo: Int = 1, size: Int = 10) -> AnyPublisher<Data, NSError> {
        
        var parameter = Parameters()
        
        let header = [HTTPHeader(name: "Authorization", value: "15208ecfaeedf448c41c9312cd133cd5")]
        
        parameter["query"] = text.urlEncodeWithQuery
        parameter["page"]  = pageNo
        
        debugPrint("\(#function) parameter : \(parameter)")
        return self.api.requestData(url: "https://dapi.kakao.com/v2/local/search/address.json", param: parameter, header: header, method: .get).eraseToAnyPublisher()
    }
}
