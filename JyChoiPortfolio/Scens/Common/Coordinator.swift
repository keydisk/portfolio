//
//  Coordinator.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/21/24.
//

import Foundation
import SwiftUI

enum Destination {
    case contentView
    case bookInfoDetailView(BookModel)
    case webView(String)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .contentView:
            ContentView()
        case .bookInfoDetailView(let model):
            BookInfoDetailView(model: model)
        case .webView(let url):
            WebView(url: url)
        }
    }
}

//final class Coordinator: ObservableObject {
//    
//    var destination: Destination = .contentView
//    @Published private var navigationTrigger = false
//    
//    @ViewBuilder func navigationLinkSection() -> some View {
//        
//        NavigationLink(isActive: Binding<Bool>(get: getTrigger, set: setTrigger(newValue:)) ) {
//            destination.view
//        } label: {
//            EmptyView()
//        }
//        
//    }
//}
