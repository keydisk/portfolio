//
//  JyChoiPortfolioApp.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import SwiftUI


@main
struct JyChoiPortfolioApp: App {
    
    @ObservedObject var alertViewModel = GlobalAlertViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                ContentView()
            }).overlay(content: {
                
                ToastMessageView()
            }).alert(isPresented: self.$alertViewModel.showAlert, content: {
                
                if let cancelBtn = self.alertViewModel.cancelBtn {
                    Alert(title: Text(self.alertViewModel.alertTitle), message: Text(self.alertViewModel.alertMsg), primaryButton: .default(Text("확인"), action: {
                        
                        self.alertViewModel.confirmBtn?.action()
                    }), secondaryButton: .cancel(Text(self.alertViewModel.confirmBtn?.title ?? ""), action: {
                        
                        cancelBtn.action()
                    }))
                } else {
                    
                    Alert(title: Text(self.alertViewModel.alertTitle), message: Text(self.alertViewModel.alertMsg), dismissButton: .default(Text(self.alertViewModel.confirmBtn?.title ?? ""), action: {
                        
                        self.alertViewModel.confirmBtn?.action()
                    }) )
                }
                
            })
        }
        
    }
}
