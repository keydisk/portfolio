//
//  CommonViewModel.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/12/24.
//

import Foundation
import UIKit
import Combine

class CommonViewModel: ObservableObject {
    
    @Published public var keyboardHeight: CGFloat = 0
    
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
        let userInfo = notification.userInfo!
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        self.keyboardHeight = keyboardRectangle.height
    }
    
    @objc func keyboardDidShow(_ notification:Notification)  { }
    
    @objc func keyboardWillHide(_ notification:Notification) { }
    
    @objc func keyboardDidHide(_ notification:Notification)  {
        
        self.keyboardHeight = 0
    }
}
