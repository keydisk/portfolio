//
//  RefeatModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import SwiftUI

/// List나 ForEach에 사용할 모델
struct RefeatModel<T>: Identifiable {
    
    let id: String
    let metaData: T
}
