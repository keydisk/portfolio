//
//  CommonViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/12/24.
//

import Foundation
import UIKit
import Combine

/// 공통으로 사용할 로직을 모아 놓은 뷰 모델
class CommonViewModel: ObservableObject {
    
    @Published public var showKeyboard: Bool = false
    
    init() {
        
    }
    
    /// 키보드 사용시 사용하는 노티
    public func useKeyboardNoti() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    public func unuseKeyboardNoti() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification,  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification,  object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) { 
        
        self.showKeyboard = true
    }
    
    @objc func keyboardDidShow(_ notification:Notification)  { }
    
    @objc func keyboardWillHide(_ notification:Notification) { }
    
    @objc func keyboardDidHide(_ notification:Notification)  {
        
        self.showKeyboard = false
    }
}
