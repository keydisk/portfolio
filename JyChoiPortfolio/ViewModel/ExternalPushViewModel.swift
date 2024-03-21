//
//  ExternalPushViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/21/24.
//

import Foundation
import Combine
import SwiftyJSON

/// push type에 따른 이동 결정
enum MoveViewType {
    
    /// 책 정보 상세로 이동
    case detailBook(BookModel)
    /// 웹페이지도 이동 전달 인자로 url을 넣어 이동
    case moveWebPage(String)
    /// 이동 하지 않기
    case none
}

/// 외부에서 넘어온 푸시 타입을 보고 이동할지 말지 결정
class ExternalPushViewModel: ObservableObject {
    
    @Published var moveType: MoveViewType = .none {
        willSet(newValue) {
            self.movePushType.send(newValue)
        }
    }
    
    let movePushType = PassthroughSubject<MoveViewType, Never>()
    
    var value: String {
        
        if case let .moveWebPage(value) = self.moveType {
            return value
        } else {
            return ""
        }
    }
    
    /// 푸시 url을 수신해 푸시 정보를 설정
    func setPushInfo(_ url: URL) {
    
        let components = URLComponents(string: url.absoluteString)
//                        "jychoiPortfolio://?type=moveWebPage&value=https://www.naver.com"
        for item in components?.queryItems ?? [] {
            
            switch item.name {
            case "type" : // 푸시 타입
                if let value = item.value, let queryItems = components?.queryItems {
                    self.setPushType(value, queryItems);
                }
                
                break
            default :
                break
            }
        }
    }
    
    /// 값만 따로 가져오기
    private func getValue(_ url: [URLQueryItem]) -> String? {
        
        for url in url {
            if url.name == "value", let value = url.value {
                
                return value
            }
        }
        
        return nil
    }
    /// 푸시 타입 설정
    private func setPushType(_ value: String, _ url: [URLQueryItem]) {
        
        switch value {
        case "detailBook" :
            if let value = self.getValue(url) {
                self.requestBookInfo(value, type: .isbn)
            }
            
            break
        case "moveWebPage":
            if let value = self.getValue(url) {
                self.moveType = .moveWebPage(value)
            }
            
            break
        default:
            break
        }
        
    }
    
    let api = SearchAPIs()
    
    var anyCancelation: AnyCancellable?
    
    /// 책 상세 정보 요청
    private func requestBookInfo(_ text: String, type: SearchTarget) {
        
        self.anyCancelation?.cancel()
        self.anyCancelation = self.api.requestBookList(text: text, target: type, sortingOption: .accuracy, pageNo: 1, size: PageDataModel.pageSize).receive(on: DispatchQueue.main).receive(on: DispatchQueue.main).sink(receiveCompletion: {complete in
            
            switch complete {
            case .finished:
                break
            case .failure(let error):
                print("receiveCompletion error : \(error)")
                break
            }
        }, receiveValue: {[weak self] data in
            
            do {
                
                let json = JSON(data)
                
                let list = try JSONDecoder().decode([BookModel].self, from: json["documents"].rawData())
                
                if type == .isbn, let firstData = list.first {
                    
                    self?.moveType = .detailBook(firstData)
                }
                
            } catch let error {
                
                print("receiveValue error : \(error)")
            }
            
        })
        
        
    }
}
