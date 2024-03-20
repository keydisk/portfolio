//
//  LoginView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/19/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                    Text("닫기").foregroundColor(.black)
                }.padding([.leading, .top], 10)
                Spacer()
            }
            
            AppleSigninButton()
            
            Spacer()
        }
    }
}

/// 애플 로그인 버튼
struct AppleSigninButton : View {
    
    var body: some View{
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                switch result {
                case .success(let authResults):
                    #if DEBUG
                    print("Apple Login Successful")
                    #endif
                    
                    switch authResults.credential {
                        
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                           // 계정 정보 가져오기
                            let userIdentifier = appleIDCredential.user
                            let fullName = appleIDCredential.fullName
//                            let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
//                            let email = appleIDCredential.email
//                            let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
//                            let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                        
#if DEBUG
                        print("fullName : \(fullName) userIdentifier : \(userIdentifier)")
                        #endif
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
            }
        ).frame(width : UIScreen.main.bounds.width * 0.9, height:50).cornerRadius(5)
    }
}

#Preview {
    LoginView()
}
