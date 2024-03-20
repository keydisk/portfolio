//
//  DetailViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import Combine
import Foundation
import UIKit
import SwiftyJSON

/// 상세로 이동
class DetailViewModel: ObservableObject {
    
    let api = SearchAPIs()
    var model: BookModel?
    
    @Published var samePulisherList: [BookModel] = []
    @Published var sameAuthList: [BookModel] = []
    @Published var selectModel: BookModel!
    
    /// 클립보드 복사
    func setClipboard(_ text: String) {
        
        UIPasteboard.general.string = text
        ToastMessage.shared.setMessage("\(text)가 클립보드에 복사 되었습니다.")
    }
    
    var anyCancelation: AnyCancellable?
    
    /// 작가와 출판사
    func requestData() {
        
        guard let model = self.model, let author = model.authors.first else {
            return
        }
        
        self.anyCancelation?.cancel()
        self.anyCancelation = self.api.requestBookList(text: author, target: .person, sortingOption: .latest, pageNo: 1, size: PageDataModel.pageSize).merge(with: self.api.requestBookList(text: model.publisher, target: .publisher, sortingOption: .latest, pageNo: 1, size: PageDataModel.pageSize) ).receive(on: DispatchQueue.main).sink(receiveCompletion: {complete in
            
            switch complete {
            case .finished:
                break
            case .failure(let error) :
                break
            }
        }, receiveValue: {[weak self] data in
            
            do {
                
                let json = JSON(data)
                
                var list = try JSONDecoder().decode([BookModel].self, from: json["documents"].rawData())
                var lastId = Int(1)
                
                list = list.filter({model in
                    model.isbn != self?.model?.isbn
                }).map({model in
                    
                    var model = model
                    
                    model.index = lastId
                    model.id    = "\(lastId)"
                    
                    lastId += 1
                    
                    return model
                })
                
                print("json : \(json) list : \(list.count)")
                
                if json[SearchAPIs.searchType].string == SearchTarget.person.rawValue {
                    
                    self?.sameAuthList     = list
                } else if json[SearchAPIs.searchType].string == SearchTarget.publisher.rawValue {
                    
                    self?.samePulisherList = list
                }
                
                self?.objectWillChange.send()
                
            } catch let error {
                
                print("receiveValue error : \(error)")
            }
        })
    }
    
}
