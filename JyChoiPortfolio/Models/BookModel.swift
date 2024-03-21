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
    
    var printAuthor: String {
        if let first = self.authors.first {
            if self.authors.count == 1 {
                
                return "\(first)"
            } else {
                
                return "\(first.appending("외 \(self.authors.count - 1)"))"
            }
        }
        
        return " - "
    }
    
    /// 여러명의 저자 동시에 출력
    var printAuthors: String {
        if let first = self.authors.first {
            if self.authors.count == 1 {
                
                return first
            } else {
                
                return self.authors.reduce("", {state, current in
                    
                    if state == "" {
                        
                        return current
                    } else {
                        
                        return state.appending(", \(current)")
                    }
                })
            }
        }
        
        return " - "
    }
    
    let authors: [String]
    let contents, datetime, isbn: String
    var printContents: String {
        
        contents.replacingOccurrences(of: "", with: "\n□")
    }
    
    var printDate: String {
        
        let date = Date(fromString: self.datetime, format: "yyyy-mm-dd'T'HH:mm:ss.SSSZZZZ")
        
        return "출간일 : \(date?.toString(format: "yyyy-MM-dd") ?? "")"
    }
    
    var printDateWithoutTitle: String {
        
        let date = Date(fromString: self.datetime, format: "yyyy-mm-dd'T'HH:mm:ss.SSSZZZZ")
        
        return date?.toString(format: "yyyy-MM-dd") ?? ""
    }
    
    let price: Int
    let publisher: String
    let salePrice: Int
    
    /// 할인 금액이 존재하지 않을 경우 -1이 나옴
    var printPrice: String {
        
        if salePrice == -1 {
            
            "가격 : \(price.moneyString)"
        } else {
            
            "할인가 : \(salePrice.moneyString) 정상가 : \(price.moneyString)"
        }
        
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
