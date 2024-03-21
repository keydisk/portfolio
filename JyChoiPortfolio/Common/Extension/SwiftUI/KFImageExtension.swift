//
//  KFImageExtension.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/20/24.
//

import Kingfisher
import SwiftUI

extension KFImage {
    
    /// 디폴트 책 이미지 적용.
    func applyDefaultBookImg(_ defaultImgNm: String) -> Self {
        self.placeholder({
            
            Image(defaultImgNm)
        })
    }
}
