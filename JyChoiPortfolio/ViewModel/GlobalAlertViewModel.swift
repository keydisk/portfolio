//
//  GlobalAlertViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/12/24.
//

import Foundation

struct AlertBtnModel {
    
    let title: String
    let action: () -> Void
}

/// 얼럿을 아무때나 표시하기 위해 사용
class GlobalAlertViewModel: ObservableObject {
    
    @Published var showAlert = false
    static let shared = GlobalAlertViewModel()
    
    var alertMsg: String = ""
    var alertTitle: String = ""
    var confirmBtn: AlertBtnModel?
    var cancelBtn: AlertBtnModel?
    
    
    func showAlert(title: String? = nil, message: String? = nil, confirmBtn: AlertBtnModel?, cancelBtn: AlertBtnModel? = nil) {
        
        if let title = title {
            
            self.alertTitle = title
        }
        
        if let message = message {
            
            self.alertMsg = message
        }
        
        self.confirmBtn = confirmBtn
        self.cancelBtn  = cancelBtn
        
        self.showAlert = true
    }
}
