//
//  NFCReaderView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/11/24.
//

import SwiftUI

struct NFCReaderView: View {
    
    @ObservedObject var viewModel = NFCViewModel()
    @State var searchText: String = ""
    init() {
        
    }
    
    var body: some View {
        VStack {
            
            Text(viewModel.readNfcInfoText)
            HStack {
                RoundTextField(round: 10, text: self.$viewModel.writeNfcInfoText, placeHolder: "insert text", edge: EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)).frame(height: 40)
                Button("write", action: {
                    
                    self.viewModel.writeNfcData()
                })
            }
            
            Spacer()
        }.padding(.horizontal, 10).navigationTitle("NFC").onAppear(perform: {
            
            self.viewModel.beginSession()
        }).onDisappear(perform: {
            
            self.viewModel.stopSession()
        })
        
    }
}

#Preview {
    NFCReaderView()
}
