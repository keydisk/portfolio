//
//  JyChoiPortfolioApp.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import SwiftUI

@main
struct JyChoiPortfolioApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                ContentView()
            }).overlay(content: {
                
                ToastMessageView()
            })
        }
    }
}
