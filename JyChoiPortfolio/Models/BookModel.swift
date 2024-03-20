//
//  BookModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/19/24.
//

import Foundation

// MARK: - BoardElementModelElement
/// 책 정보를 가지고 있는 구조체
struct BookModel: Codable, Identifiable {
    
    var id: String = ""
    var index: Int = 0
    
    var author: String {
        if let first = self.authors.first {
            if self.authors.count == 1 {
                
                return "저자 : \(first)"
            } else {
                
                return "저자 : \(first.appending("외 \(self.authors.count - 1)"))"
            }
        }
        
        return "저자 : - "
    }
    
    let authors: [String]
    let contents, datetime, isbn: String
    var printDate: String {
        
        let date = Date(fromString: self.datetime, format: "yyyy-mm-dd'T'HH:mm:ss.SSSZZZZ")
        
        return "출간일 : \(date?.toString(format: "yyyy-MM-dd") ?? "")"
    }
    
    let price: Int
    let publisher: String
    let salePrice: Int
    var printPrice: String {
        "세일가 : \(salePrice.moneyString) 정상가 : \(price.moneyString)"
    }
    
    let status: String
    
    let thumbnail: String
    let title: String
    let translators: [String]
    var printTranslators: String {
        self.translators.reduce("", {state, current in
            if state == "" {
                return current
            } else {
                return state.appending(", \(current)")
            }
        })
    }
    let url: String

    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher
        case salePrice = "sale_price"
        case status, thumbnail, title, translators, url
    }
}

typealias BoardElementModel = [BookModel]
