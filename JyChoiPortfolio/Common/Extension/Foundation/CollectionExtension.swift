//
//  CollectionExtension.swift
//  iOSTestProject
//
//  Created by JuYoung choi on 2/20/24.
//

import Foundation

extension Collection {

    /// 배열 인덱스가 범위를 넘어 갔는지 확인
    subscript (s index: Index) -> Element? {
        
        return self.indices.contains(index) ? self[index] : nil
    }
}
