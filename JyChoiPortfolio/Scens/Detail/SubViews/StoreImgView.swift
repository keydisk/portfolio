//
//  StoreImgView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import SwiftUI
import Kingfisher

/// 지점 이미지 셀
struct StoreImgView: View {
    
    let thumbnailUrl: URL
    let geo: GeometryProxy
    @Binding var imgH: CGFloat
    
    init(_ thumbnailUrl: URL, geo: GeometryProxy, imgH: Binding<CGFloat>) {
        
        self.thumbnailUrl = thumbnailUrl
        self.geo = geo
        self._imgH = imgH
    }
    
    var body: some View {
        VStack {
            KFImage(self.thumbnailUrl).resizable().onSuccess({result in
                
                let rate = geo.size.width / result.image.size.width
                
                guard self.imgH < (rate * result.image.size.height) else {
                    return
                }
                
                self.imgH = rate * result.image.size.height
            }).cancelOnDisappear(true).listRowInsets(EdgeInsets() )
        }.listRowInsets(EdgeInsets() ).listRowSeparator(.hidden).frame(width: geo.size.width)
    }
}


