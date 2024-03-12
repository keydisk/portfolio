//
//  UIScrollViewWrapper.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import UIKit
import SwiftUI
import SnapKit

class ScrollViewCoordinator: NSObject, UIScrollViewDelegate {
    
    @Binding var offset: CGPoint
    @Binding var pageNo: Int
    
    init(offset: Binding<CGPoint>, pageNo: Binding<Int>) {
        
        self._offset = offset
        self._pageNo = pageNo
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.offset = scrollView.contentOffset
        self.pageNo = Int(scrollView.contentOffset.x / scrollView.frame.size.width) + 1
    }
    
}

struct PagingScrollView<Content: View>: UIViewRepresentable {
    
    var content: Content
    @Binding var offset: CGPoint
    @Binding var currentPageNo: Int
    let delegateObj: ScrollViewCoordinator
    
    init(offset: Binding<CGPoint>, currentPageNo: Binding<Int>, @ViewBuilder content: @escaping () -> Content) {
        
        self.content = content()
        self._offset = offset
        self._currentPageNo = currentPageNo
        
        self.delegateObj = ScrollViewCoordinator(offset: self._offset, pageNo: self._currentPageNo)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let scrollView = UIScrollView()
        
        let hostview = UIHostingController(rootView: content)
        
        scrollView.addSubview(hostview.view)
        
        hostview.view.snp.makeConstraints({m in
            m.edges.equalToSuperview()
            m.height.equalToSuperview()
        })
        
        // 페이징 설정
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.delegate = self.delegateObj
    }
}
