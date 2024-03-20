# iOS앱 개발자 ChoiJuyoung

## 적용 아키텍쳐 및 언어
MVVM, Swift

## 사용 프레임웍
UIKit, SwiftUI, WebKit, SnapKit(UIKit 랩핑할일 있을때 사용), Combine, Alamofire, SwiftyJson

## 구현사항
* 공지사항 (WKWebView 랩핑해서 사용)
* 화면에 표시하는 데이터는 카카오 책 검색 사용
* 폰트는 spoqa 폰트 사용
* 애플 로그인 구현

## 향후 개선사항

글로벌 얼럿 호출 코드
<pre>
  <code>
    GlobalAlertViewModel.shared.showAlert(message: message, confirmBtn: AlertBtnModel(title: "확인", action: {
            completionHandler()
        }))

    GlobalAlertViewModel.shared.showAlert(message: message, confirmBtn: AlertBtnModel(title: "확인", action: {
            completionHandler(true)
        }), cancelBtn: AlertBtnModel(title: "취소", action: {
            completionHandler(false)
        }))
  </code>
</pre>

토스트 메시지 호출
<pre>
  <code>
    ToastMessage.shared.setMessage("메시지")
  </code>
</pre>
