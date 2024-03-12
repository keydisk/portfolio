//
//  IntExtension.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import Foundation

extension Int {
    
    /// 100,000 <- 이런 형식으로 숫자에 ,을 넣어서 리턴
    var moneyString: String {
        
        let numberFormatter = NumberFormatter();
        numberFormatter.numberStyle = .decimal
        
        let moneyNum = NSNumber(value: self)
        
        return numberFormatter.string(from: moneyNum)?.replacingOccurrences(of: ".", with: ",") ?? "0"
    }
}
