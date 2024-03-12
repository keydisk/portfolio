//
//  APIClient.swift
//  iOSTestProject
//
//  Created by JuYoung choi on 2/19/24.
//

import Foundation
import Combine

import Alamofire


/// api 통신 모듈
class APIClient {
    
    static let shared = APIClient()
    let defaultHeader: HTTPHeaders = [:]
    
    /// 통신 모듈 (Combine으로 구현) 
    ///
    /// - Parameters:
    ///   - url: url path 부분
    ///   - data: 보낼 데이터
    ///   - param: key value 타입의 데이터
    ///   - method: 데이터 전송 타입 ex) get, post, put ....
    /// - Returns: PassThrought타입의 데이터
    func requestData(url: String, data: String? = nil, param: Parameters = [:], header: [HTTPHeader] = [], method: HTTPMethod) -> PassthroughSubject<Data, NSError> {
        
        let combine = PassthroughSubject<Data, NSError>()
        
        let callUrl = url.hasPrefix("http") ? url : ApiConstants.baseUrl.appending(url)
        var dataRequest: DataRequest!
        
        do {
            
            if method == .get {
                
                dataRequest = AF.request(callUrl, method: method, parameters: param, headers: self.defaultHeader)
                
            } else {
                
                var request = try URLRequest(url: callUrl, method: method)
                request.httpBody = data?.data(using: .utf8)
                request.timeoutInterval = ApiConstants.timeout
                self.defaultHeader.dictionary.keys.forEach({key in
                    request.setValue(self.defaultHeader[key]!, forHTTPHeaderField: key)
                })
                
                header.forEach({data in
                    request.setValue(data.value, forHTTPHeaderField: data.name)
                })
                
                dataRequest = AF.request(request)
            }
            
            debugPrint("callUrl : \(callUrl) param: \(param)")
            
            dataRequest.validate(statusCode: 200..<300)
                .responseData(completionHandler: {responseData in
                
                guard let data = responseData.data else {
                    
                    if let error = responseData.error {
                        
                        debugPrint("error : \(error)")
                        combine.send(completion: .failure(error as NSError) )
                    } else {
                        
                        let error = NSError(domain: "", code: 999)
                        combine.send(completion: .failure(error as NSError) )
                    }
                    
                    combine.send(completion: .finished)
                    return
                }
                
                combine.send(data)
                combine.send(completion: .finished)
            })
        } catch let error {
            debugPrint("error : \(error)")
        }
        
        return combine
    }
}
