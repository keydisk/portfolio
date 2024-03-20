//
//  UIApplicationExtension.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/19/24.
//

import Foundation
import UIKit

extension UIApplication {
    
    func endEditing() {
        
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
