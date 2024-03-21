//
//  SearchTarget.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/20/24.
//

import Foundation

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

