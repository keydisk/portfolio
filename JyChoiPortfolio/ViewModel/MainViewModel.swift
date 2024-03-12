//
//  MainViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import Foundation
import Combine
import CoreLocation

enum SortingType {
    
    case distance
    case price
}

class MainViewModel: CommonViewModel {
    
    /// 검색 키워드
    @Published var searchText = "" {
        willSet(newValue) {
            
            if newValue == "" {
                self.list = self.originList
            } else {
                self.list = self.originList.filter({model in
                    model.address.contains(newValue) || model.metaData.title.contains(newValue)
                })
            }
        }
    }
    
    /// 전체 지점 리스트
    @Published var list: [StoreModel] = []
    var originList: [StoreModel] = []
    
    @Published var selectOption: SortingType {
        willSet(newValue) {
            
            if newValue == .distance {
                
                self.list = self.list.sorted(by: {c1, c2 in
                    c1.distance < c2.distance
                })
            } else {
                self.list = self.list.sorted(by: {c1, c2 in
                    c1.minimumPrice < c2.minimumPrice
                })
            }
        }
    }
    
    @Published var refreshList: Bool = false {
        
        willSet(newValue) {
            print("refreshList : \(newValue)")
        }
    }
    
    /// 스토어 상세로 이동
    var selectStoreModel = PassthroughSubject<StoreModel, Never>()
    @Published var selectModel: StoreModel?
    @Published var moveDetailView: Bool = false
    
    var cancelationList  = Set<AnyCancellable>()
    
    
    override init() {
      
        self.selectOption = .distance
        
        super.init()
        #if DEBUG
        let tagList = [TagModel<Bool>(title: "직영", id: "d1", metaData: false), TagModel<Bool>(title: "24시간", id: "d2", metaData: true), TagModel<Bool>(title: "무료주차", id: "d3", metaData: true)]
    
        
        let imgList = [ImgElement(id: URL(string: "https://cdn.newsroad.co.kr/news/photo/202403/27876_39619_131.jpg")!), ImgElement(id:URL(string: "https://cdn.newsroad.co.kr/news/photo/202403/27855_39598_1410.jpg")!), ImgElement(id:URL(string: "https://cdn.newsroad.co.kr/news/photo/202402/27738_39450_5613.jpg")!) ]
        
        self.originList =
        [StoreModel(id: "0", storeImgList: imgList, metaData: StorePointModel(id: "1", title: "올림픽 공원점", location: CLLocationCoordinate2D(latitude: 37.51545, longitude: 127.11487), thumbnailUrl: URL(string: "https://gongu.copyright.or.kr/gongu/wrt/cmmn/wrtFileImageView.do?wrtSn=13223550&filePath=L2Rpc2sxL25ld2RhdGEvMjAxOS8yMS9DTFMxMDAwNC8xMzIyMzU1MF9XUlRfMjAxOTExMjFfMQ==&thumbAt=Y&thumbSe=b_tbumb&wrtTy=10004")!), address: "서울 송파구 백제고분로 505 B1층", tagList: tagList, minimumPrice: 70560, distance: 1480),
         
         StoreModel(id: "1", storeImgList: imgList.reversed(), metaData: StorePointModel(id: "2", title: "잠실점", location: CLLocationCoordinate2D(latitude: 37.50225, longitude: 127.09649), thumbnailUrl: URL(string: "https://img.etnews.com/news/article/2024/02/16/news-p.v1.20240216.2819161319b94558bb8cb16ea881afb7_P1.png")!), address: "서울 송파구 삼학사로 47 B1층", tagList: tagList, minimumPrice: 179010, distance: 1630),
         
         StoreModel(id: "2", storeImgList: imgList.reversed(), metaData: StorePointModel(id: "3", title: "롯데월드점", location: CLLocationCoordinate2D(latitude: 37.51133, longitude: 127.09626), thumbnailUrl: URL(string: "https://prs.ohou.se/apne2/any/uploads/productions/v1-204356443439168.jpg?gif=1&w=640&h=640&c=c&webp=1")!), address: "서울 송파구 올림픽로 240 (잠실동) 롯데월드 웰빙센터 8F", tagList: tagList, minimumPrice: 187920, distance: 1910),
         
         StoreModel(id: "3", storeImgList: imgList, metaData: StorePointModel(id: "4", title: "거여역점", location: CLLocationCoordinate2D(latitude: 37.49644, longitude: 127.14097), thumbnailUrl: URL(string: "https://image.ohou.se/i/bucketplace-v2-development/uploads/deals/170657595883924878.png?gif=1&w=640&h=640&c=c&webp=1")!), address: "서울 송파구 백제고분로 505 B1층", tagList: tagList, minimumPrice: 59850, distance: 1480),
         StoreModel(id: "4", storeImgList: imgList.reversed(), metaData: StorePointModel(id: "4", title: "가든파이브점", location: CLLocationCoordinate2D(latitude: 37.47872, longitude: 127.11842), thumbnailUrl: URL(string: "https://image.ohou.se/i/bucketplace-v2-development/uploads/productions/168836707697701561.jpg?gif=1&w=640&h=640&c=c&webp=1")!), address: "서울 송파구 충민로 10 가든파이브툴 B1", tagList: tagList, minimumPrice: 121600, distance: 2680)
        ]
        
        self.list = self.originList
        #endif
        
        self.selectModel  = StoreModel(id: "", storeImgList: [], metaData: StorePointModel(id: "3", title: "롯데월드점", location: CLLocationCoordinate2D(latitude: 37.51133, longitude: 127.09626), thumbnailUrl: nil), address: "", tagList: [], minimumPrice: 0, distance: 0)
        
        self.selectStoreModel.sink(receiveValue: {[unowned self] model in
            
            self.selectModel    = model
            self.moveDetailView = true
        }).store(in: &self.cancelationList)
        
        
    }
}
