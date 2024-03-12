//
//  CommonWebView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import SwiftUI
import WebKit

/// 공통으로 사용하는 웹뷰
struct CommonWebView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        let webView = CustomWKWebView()
        webView.isUseProgressBar = true
        
        guard let url = URL(string: url) else {
            
            return webView
        }
        
        webView.requestUrl(requestUrl: url.absoluteString)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<CommonWebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
}

#Preview {
    CommonWebView(url: "https://www.naver.com")
}
