//
//  ToastMessageView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/8/24.
//

import SwiftUI
import Combine

class ToastMessage: ObservableObject {
    static let shared = ToastMessage()
    
    @Published var msg = ""
    @Published var show = false
    
    var timer: Timer?
    func setMessage(_ msg: String) {
        
        self.msg  = msg
        self.show = true
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {timer in
            timer.invalidate()
            
            withAnimation {
                self.show = false
            }
        })
    }
}

struct ToastMessageView: View {
    
    @ObservedObject var viewModel = ToastMessage.shared
    
    init() {
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            HStack {
                Text(self.viewModel.msg).foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 10)
            }.background(
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).fill(Color(r: 100, g: 100, b: 100))
            ).padding(.bottom, 30)
        }.animation(.easeInOut(duration: 0.3), value: self.viewModel.show).opacity(self.viewModel.show ? 1 : 0)
    }
}

#Preview {
    ToastMessageView()
}
