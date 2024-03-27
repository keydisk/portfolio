# iOS앱 개발자 ChoiJuyoung

## 적용 아키텍쳐 및 언어
MVVM, Swift

## 사용 프레임웍
* iOS 지원 버전 : 14.0
* Swfit version : 5.0
* 사용 프레임웤 :
  - Combine, SwiftUI : swiftUI로 작성된 UI작성을 위해 사용
  - alamofire 5.9.0 : http 통신을 위해서
  - swiftyJson 5.0.1 : 제이슨 처리를 위해 사용
  - kingfisher 7.11.0 : 이미지 다운로드 활용을 위해 사용.

## 구현사항
* 책 검색 (키보드로 입력시 입력이 끝나고 0.5초 이후에 검색 debounce사용)
* [카카오 책 검색 api 사용](https://dapi.kakao.com/v3/search/book)
* 책 상세보기
* 색 상세보기에서 책 선택시 웹뷰로 이동

## 향후 개선사항
* 스킴으로 모든 기능을 다 연결해서 외부에서 앱의 원하는 기능으로 연결 되게 구현

책 검색을 위해 debounce가 적용된 코드
<pre>
  <code>
  self.searchBookListFromKeyword.debounce(for: 0.5, scheduler: DispatchQueue.global(qos: .background)).sink(receiveValue: {[weak self] text in

    self?.pageModel.currentPageNo = 1
    self?.requestBookList(text)    
    self?.objectWillChange.send() 
  }).store(in: &self.cancelationList)
  </code>
</pre>

책 상세보기에서 같은 작가 & 같은 출판사의 책 조회시 두 api호출 후 두 이벤트가 모두 발생한 이후 처리를 위한 코드
<pre>
  <code>
  self.anyCancelation?.cancel()
  self.anyCancelation = self.api.requestBookList(text: author, target: .person, sortingOption: .latest, pageNo: 1, size: PageDataModel.pageSize).merge(with: self.api.requestBookList(text: model.publisher, target: .publisher, sortingOption: .latest, pageNo: 1, size: PageDataModel.pageSize) ).receive(on: DispatchQueue.main)
  </code>
</pre>
