//
//  NotificationView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import SwiftUI
import Combine
import WebKit

class NotificationViewViewModel: ObservableObject {
    
    let notShow = "dontLookBranchNotiForAday"
        
    /// 하루 안보기
    func setDontLookNoti() {
        
        UserDefaults.standard.setValue(Date(), forKey: self.notShow)
        UserDefaults.standard.synchronize()
    }
    
    /// 화면에 표시 할지 말지 표시
    var getNotiShow: Bool {
        
        guard let date = UserDefaults.standard.object(forKey: self.notShow) as? Date, let diff = Date().dailyDiffence(compareDate: date) else {
            
            return true
        }
        
        if diff > 1 {
            
            UserDefaults.standard.removeObject(forKey: self.notShow)
            UserDefaults.standard.synchronize()
            return true
        } else {
            
            return false
        }
    }
}

/// 공지사항 뷰
struct NotificationView: View {
    
    let url: String
    @State var hidenView = true
    @ObservedObject var viewModel = NotificationViewViewModel()
    
    init(url: String, hidenView: Bool = false) {
        
        self.url = url
    }
    
    func hideNotificationView() {
        
        withAnimation {
            self.hidenView.toggle()
        }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(spacing: 0) {
                CommonWebView(url: self.url)
                
                HStack(spacing: 0) {
                    
                    VStack {
                        Spacer()
                        Text("닫기").foregroundColor(.white)
                        Spacer()
                    }
                    .frame(width: geo.size.width * 0.4)
                    .background(Color.blue).onTapGesture {
                        
                        self.hideNotificationView()
                    }
                    VStack {
                        Spacer()
                        Text("하루동안 안보기").foregroundColor(.white)
                        Spacer()
                    }
                    .frame(width: geo.size.width * 0.6)
                    .background(Color.gray).onTapGesture {
                        
                        self.hideNotificationView()
                        self.viewModel.setDontLookNoti()
                    }
                }.frame(height: 60)
            }.cornerRadius(20)
        }.padding(.horizontal, 50).padding(.vertical, 100).background(Color(r: 125, g: 125, b: 125, a: 50)).opacity(self.hidenView ? 0 : 1).onAppear(perform: {
            
            self.hidenView = self.viewModel.getNotiShow ? false : true
        })
    }
}

#Preview {
    NotificationView(url: "https://www.naver.com")
}
