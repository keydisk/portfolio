//
//  TopImgBottomTextView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI

enum IconType {
    
    case useGuide
    case parking
    case secureAndEnter
    case wifiInfo
}

struct TopImgBottomTextView: View {
    
    let buttonType: IconType
    var imgNm: String = ""
    var bottomText: String = ""
    
    @Binding var selectType: IconType
    
    init(buttonType: IconType, selectType: Binding<IconType>) {
        
        self.buttonType = buttonType
        self._selectType = selectType
        
        switch self.buttonType {
        case .useGuide:
            self.imgNm = "doc.text.below.ecg"
            self.bottomText = "이용안내"
        case .parking:
            self.imgNm = "parkingsign"
            self.bottomText = "주차"
        case .secureAndEnter:
            self.imgNm = "person.text.rectangle.fill"
            self.bottomText = "보안/출입"
        case .wifiInfo:
            self.imgNm = "wifi.router"
            self.bottomText = "와이파이"
        }
    }
    
    var body: some View {
        VStack {
            
            Image(systemName: self.imgNm)
            Text(self.bottomText).padding(.top, 10)
            Rectangle().foregroundColor(Color.gray).frame(height: 3).opacity(selectType == buttonType ? 1 : 0)
        }
        
    }
}
