//
//  CommonWebView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import SwiftUI
import WebKit

/// 웹뷰를 swiftUI에서 사용하기 위해 랩핑
struct CommonWebView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        let webView = CustomWKWebView()
        webView.isUseProgressBar = true
//        webView.title
        
        guard let url = URL(string: url) else {
            
            return webView
        }
        webView.requestUrl(requestUrl: url.absoluteString)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<CommonWebView>) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        print("request url : \(url)")
        
        webView.load(URLRequest(url: url))
    }
}

struct WebView: View {
    
    let url: String
    @Environment(\.presentationMode) var presentationMode
    @State var title: String = ""
    
    var body: some View {
        CommonWebView(url: url).navigationBarBackButtonHidden(true)
            .navigationTitle(self.title)
            .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label:  {
                    Image(systemName: "arrowshape.backward")
                }.accentColor(.gray)
                
            })
        })
    }
}

#Preview {
    WebView(url: "https://www.naver.com")
}
