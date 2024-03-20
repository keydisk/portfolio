//
//  MainViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import Foundation
import Combine
import CoreLocation
import SwiftyJSON

/// 정렬 타입
enum SortingType: String {
    
    case accuracy = "accuracy"
    case latest = "latest"
}

enum SearchTarget: String {
    
    case title = "title"
    case isbn = "isbn"
    case publisher = "publisher"
    case person = "person"
    
    /// 각각의 이넘별 타이틀
    var printText: String {
        switch self {
        case .isbn:
            return "ISBN"
        case .title:
            return "제목"
        case .publisher:
            return "출판사"
        case .person:
            return "인명"
        }
    }
    
    static let searchList: [RefeatModel<SearchTarget>] = [RefeatModel(id: "1", metaData: .title), RefeatModel(id: "2", metaData: .isbn), RefeatModel(id: "3", metaData: .publisher), RefeatModel(id: "4", metaData: .person)]
    
    static let list: [SearchTarget] = [.title, .isbn, .publisher, .person]
}

class MainViewModel: CommonViewModel {
    
    let api = SearchAPIs()
    
    /// 검색 키워드
    @Published var searchText = "" {
        willSet(newValue) {
            
            if newValue == "" {
                
                self.list = []
            } else if self.searchText != newValue {
                
                self.pageModel.currentPageNo = 1
                self.requestBookList(newValue)
            }
        }
    }
    
    @Published var target: SearchTarget = .title
    
    /// 검색한 책 리스트
    @Published var list: [BookModel] = []
    let pageTop = PassthroughSubject<Bool, Never>()
    
    @Published var pageModel: PageDataModel
    
    @Published var sortingOption: SortingType = .accuracy
    
    /// iOS 15이상에서 사용하려고 만듬
    @Published var refreshList: Bool = false {
        
        willSet(newValue) {
            print("refreshList : \(newValue)")
        }
    }
    
    /// 책 상세로 이동
    @Published var selectBookModel = CurrentValueSubject<BookModel?, Never>(nil)
    @Published var moveDetailView: Bool = false
    
    var cancelationList  = Set<AnyCancellable>()
    
    override init() {
        
        self.pageModel = PageDataModel(isEnd: true, pagableCnt: 0, totalCnt: 0)
        self.sortingOption = .accuracy
        
        super.init()
        
        self.selectBookModel.sink(receiveValue: {[weak self]model in
            
            guard model != nil else {
                
                return
            }
            
            self?.moveDetailView = true
            self?.objectWillChange.send()
        }).store(in: &cancelationList)
        
        self.useKeyboardNoti()
    }
    
    /// 정렬 타입 선택
    func selectSorting(_ type: SortingType) {
        
        self.pageTop.send(true)
        
        guard self.sortingOption != type else {
            return
        }
        
        self.sortingOption = type
        self.pageModel.currentPageNo = 1
        
        self.requestBookList(self.searchText)
    }
    
    func setSelectTarget(_ type: SearchTarget) {
        
        guard self.target != type else {
            return
        }
        
        print(type)
        self.target = type
        
        guard self.searchText != "" else {
            return
        }
        
        self.requestBookList(self.searchText)
    }
    
    var anyCancelation: AnyCancellable?
    
    /// 책 리스트 요청
    private func requestBookList(_ text: String) {
        
        guard let query = text.urlEncodeWithQuery else {
            return
        }
        
        self.anyCancelation?.cancel()
        
        self.anyCancelation = self.api.requestBookList(text: query, target: self.target, sortingOption: self.sortingOption, pageNo: self.pageModel.currentPageNo, size: PageDataModel.pageSize).receive(on: DispatchQueue.main).receive(on: DispatchQueue.main).sink(receiveCompletion: {complete in
            
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
                
                var list = try JSONDecoder().decode([BookModel].self, from: json["documents"].rawData())
                var lastId = self?.pageModel.currentPageNo == 1 ? 1 : (Int(self?.list.last?.id ?? "1") ?? 1)
                
                list = list.map({model in
                    
                    var model = model
                    
                    model.index = lastId
                    model.id    = "\(lastId)"
                    
                    lastId += 1
                    
                    return model
                })
                
                if self?.pageModel.currentPageNo == 1 {
                    
                    self?.list = list
                } else {
                    list.forEach({model in
                        
                        self?.list.append(model)
                    })
                }
                
                print("json[\"meta\"] : \(json["meta"])")
                self?.pageModel = PageDataModel(isEnd: json["meta"]["is_end"].boolValue, pagableCnt: json["meta"]["pageable_count"].intValue, totalCnt: json["meta"]["total_count"].intValue, currentPageNo: self?.pageModel.currentPageNo ?? 1)
                
                self?.objectWillChange.send()
                
            } catch let error {
                
                print("receiveValue error : \(error)")
            }
            
        })
    }
    
    func nextPage(_ model: BookModel) {
        
        guard "\(model.index)" == self.list.last?.id, self.pageModel.isEnd == false else {
            
            return
        }
        
        self.pageModel.currentPageNo += 1
        self.requestBookList(self.searchText)
    }
}
