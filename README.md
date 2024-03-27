# iOS앱 개발자 ChoiJuyoung

## 적용 아키텍쳐 및 언어
MVVM, Swift

## 사용 프레임웍
UIKit, SwiftUI, MapKit, WebKit, SnapKit, Combine, Alamofire, SwiftyJson

## 구현사항
* 공지사항 (WKWebView 랩핑해서 사용)
* 지도보기 (Apple map 사용)
* 화면에 표시하는 데이터는 앱 내부에 코드 레벨로 저장
* 앱에서 사용하는 이미지는 뉴스 기사에서 발췌
* 앱내부에서 사용하는 아이콘 이미지는 시스템 이미지 사용
* 폰트는 spoqa 폰트 사용
* keyboard toolbar
* NFC 읽기 및 쓰기 구현
* * oauth 사용 (apple login)

## 향후 개선사항
* 스킴으로 모든 기능을 다 연결해서 외부에서 앱의 원하는 기능으로 연결 되게 구현


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
