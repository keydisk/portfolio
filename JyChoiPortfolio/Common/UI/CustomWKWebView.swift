//
//  CustomWKWebView.swift
//
//  Created by jychoi on 2017. 4. 4..
//  Copyright © 2017년 jychoi. All rights reserved.
//

import UIKit
import WebKit

import CoreLocation
import Photos
import SnapKit

//MARK: -
/// WKWebView 외부에서 정의하는 딜리게이트
@objc protocol CustomWKWebViewDelegate: AnyObject {
    
    /** 인디게이터 시작 */
    @objc optional func startWebViewIndigator()
    /** 인디게이터 정지 */
    @objc optional func stopWebViewIndigator()
    
    /// 웹뷰에서 호출하는 request를 진행 시킬지 말지 결정.
    ///
    /// - Parameter callUrl: 요청 URL
    /// - Returns: true  <- 계속 진행, false <- 정지
    func isHttpRequestUrl(callUrl:URL?) -> Bool
    
    /// script message 수신
    ///
    /// - Parameter pstrMessage: 스크립트 메시지
    @objc optional func getScriptMessage(message:String)
    
    
    /// 통신에러 처리
    ///
    /// - Parameter error: 에러 객체
    @objc optional func taskWithError(error:NSError)
    
    
    /// 웹뷰 호출이 시작
    ///
    /// - Parameter webView: 웹뷰 객체
    @objc optional func webViewLoadingStart(_ webView:CustomWKWebView)
    
    /// 웹뷰 호출이 완료 되고 호출됨
    ///
    /// - Parameter webView: 웹뷰 객체
    @objc optional func webViewLoaded(_ webView:CustomWKWebView)
    
    /// 하단 툴바를 숨김
    @objc optional func hideBottomBar()
    
    /// 하단 툴바를 보이기
    @objc optional func showBottomBar()
    
    /// 로딩 완료
    @objc optional func loadingFinish()
    
    /// 로딩 완료
    ///
    /// - Parameter viewCtr: 뷰컨트롤러
    @objc optional func webViewPop(_ viewCtr: UIViewController)
    
    /// 다른앱 호출시 호출 됨
    @objc optional func callOtherApp()
}

class LeakAvoider: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}

// MARK: -
/// Custom WKWebView
class CustomWKWebView: WKWebView, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    deinit {
        #if DEBUG
        debugPrint("deinit CustomWKWebView")
        #endif
    }
    public var useCookie = false // 쿠키 사용시 설정
    
    public weak var webviewDelegate: CustomWKWebViewDelegate?
    
    private let EstimatedProgress    = "estimatedProgress"; // 웹뷰 로딩 프로그래바 표시를 위한 옵져버
    public  static let ScriptHandler = "observe"; // script handlers
    public  static let ScriptHandler2 = "pcc"; // 본인인증 handlers
    public  static let ScriptHandler3 = "userauthcard"; // 카드 본인인증 handlers
    
    public  var erCreatedWKWebViews: [WKWebView] = []; // 모달을 열었을때 웹뷰를 관리해주기 위한 배열
    private var perWebViewNavigations: [WKNavigation] = [];
    
    fileprivate weak var progressBar: UIProgressView?  // Progress bar
    
    public var callOtherScheme: URL? // http가 아니라 다른 스키마로 호출할때
    /// 요청한 URL을 가지고 있는 프로퍼티
    public var currentUrl: URL?
    
    public var _isUseProgressBar: Bool = false
    public var isUseProgressBar: Bool { // 프로그래스바 사용할지 않할지
        get {
            
            return self._isUseProgressBar
        }
        set {
            
            self._isUseProgressBar = newValue
            
            if newValue == false && self.progressBar != nil {
                self.progressBar?.removeFromSuperview()
            }
            else if self.progressBar == nil {
                self.drawProgressBar()
            }
        }
    }
    
    var loadingFinish: (() -> Void)?
    let networkTimeout = TimeInterval(20)
    /// 웹뷰가 속한 뷰 컨트롤러 닫기
    public var closeWebView: (() -> Void)?
    // 이전 URL
    private var _previousUrl: [URL] = []
    
    /** WKWebView 초기화 */
    public func initWKWebView(_ isNavigationGestrue: Bool = false) {
        
        self.configuration.processPool = WKProcessPool()
        
        self.configuration.userContentController.add(LeakAvoider(delegate: self), name: CustomWKWebView.ScriptHandler)
        self.configuration.userContentController.add(LeakAvoider(delegate: self), name: CustomWKWebView.ScriptHandler2)
        self.configuration.userContentController.add(LeakAvoider(delegate: self), name: CustomWKWebView.ScriptHandler3)
        self.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        self.configuration.websiteDataStore = WKWebsiteDataStore.default()
        
        self.uiDelegate         = self
        self.navigationDelegate = self
        self.allowsBackForwardNavigationGestures = isNavigationGestrue
        self.allowsLinkPreview = false
        
        self.erCreatedWKWebViews.append(self)
    }
    
    /** 프로그래스바 그리기 */
    private func drawProgressBar() {
        
        if self.progressBar != nil {
            self.bringSubviewToFront(self.progressBar!)
            return
        }
        
        let progressBar = UIProgressView()
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(progressBar)
        
        progressBar.progressTintColor = .darkGray
        progressBar.trackTintColor    = .lightGray
        progressBar.progressViewStyle = .default
        
        let xLoc   = NSLayoutConstraint(item: progressBar, attribute: .left,   relatedBy: .equal, toItem: self, attribute: .left,   multiplier: 1.0,  constant: 0.0)
        let yLoc   = NSLayoutConstraint(item: progressBar, attribute: .top,    relatedBy: .equal, toItem: self, attribute: .top,    multiplier: 1.0,  constant: 0.0)
        let width  = NSLayoutConstraint(item: progressBar, attribute: .width,  relatedBy: .equal, toItem: self, attribute: .width,  multiplier: 1.0,  constant: 0.0)
        let height = NSLayoutConstraint(item: progressBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 3.0)
        
        self.addConstraints([xLoc, yLoc, width, height]);
        
        self.progressBar = progressBar;
        
        self.progressBar?.isHidden = false
        self.progressBar?.progress = 0
        
        self.bringSubviewToFront(self.progressBar!)
        self.addObserver(self, forKeyPath: self.EstimatedProgress, options: .new, context: nil) // add observer for key path
    }
    
    override func draw(_ rect: CGRect) {
        
        if self.isUseProgressBar {
            
            self.drawProgressBar()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == self.EstimatedProgress else {
            super.observeValue(forKeyPath:keyPath, of: object, change: change, context: context)
            return
        }
        
        if self.estimatedProgress < 1  {
            
            self.drawProgressBar()
            self.progressBar?.isHidden = false
            
            let progress = Float(self.estimatedProgress)
            if self.progressBar?.progress ?? 0 > progress {
                self.progressBar?.progress = progress
            } else {
                self.progressBar?.setProgress(progress, animated: true)
            }
        } else {
            
            self.progressBar?.progress = 0
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] () in
                self?.progressBar?.alpha = 1.0
            }, completion: {[weak self] _ in
                self?.progressBar?.isHidden = true
            })
        }
    }
    
    private func stageWebViewForScreenshot() {
        let _scrollView = self.scrollView
        let pageSize = _scrollView.contentSize;
        let currentOffset = _scrollView.contentOffset
        let horizontalLimit = CGFloat(ceil(pageSize.width/_scrollView.frame.size.width))
        let verticalLimit = CGFloat(ceil(pageSize.height/_scrollView.frame.size.height))

         for i in stride(from: 0, to: verticalLimit, by: 1.0) {
            for j in stride(from: 0, to: horizontalLimit, by: 1.0) {
                _scrollView.scrollRectToVisible(CGRect(x: _scrollView.frame.size.width * j, y: _scrollView.frame.size.height * i, width: _scrollView.frame.size.width, height: _scrollView.frame.size.height), animated: true)
                 RunLoop.main.run(until: Date.init(timeIntervalSinceNow: 1.0))
            }
        }
        _scrollView.setContentOffset(currentOffset, animated: false)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        debugPrint("")
    }
    
    
    public func requestDataWithPost(body: String) {
        
    }
    
    /** 호출중인 URL 을 스택에 저장 */
    public func pushUrlStack(_ url: URL) {
        
        self._previousUrl.append(url)
    }
    
    /** history.back시 URL확인 */
    public func putUrlStack() -> URL? {
        
        return self._previousUrl.last
    }
    
    /** history.back시 URL삭제 */
    public func popUrlStack() -> URL? {
        
        let lastUrl = self._previousUrl.last
        
        if self._previousUrl.count > 0 {
            self._previousUrl.removeLast()
        }
        
        
        return lastUrl
    }
    
    override func goBack() -> WKNavigation? {
        
//        let _ = self.popUrlStack();
        return super.goBack()
    }
    
    //MARK: - UI Controll
//    public func setWebViewCornerRadius(radius: CGFloat) {
//        
//        self.bound
//    }
    
    //MARK: - go back
    public func removeResource(includeJavascript: Bool = true) {
         debugPrint("wkwebview removeResource")

        if includeJavascript {
            self.removeScriptHandler()
            
            self.uiDelegate         = nil
            self.navigationDelegate = nil
        }
         
         self.stopLoading()
         self.erCreatedWKWebViews.removeAll()
     }

    
    //MARK: - status bar
    /** comment : 스테이터스바 선택 했을때 호출되는 메소드 */
    public func selectStatusBar() {
        
        let topPoint = CGPoint(x: 0, y: 0)
        
        self.scrollView.setContentOffset(topPoint, animated: true)
    }
    
    
    //MARK: - request data
    /// 웹뷰에 요청하기
    ///
    /// - Parameters:
    ///   - url: 요청할 URL
    ///   - body: 바디
    ///   - isPost: 포스트 요청 여부
    public func requestPost(url: String, ignoreCache: Bool = false, body:[String:Any]? = nil, bodyText: String? = nil, isPost:Bool = true) {
        
        if isPost {
            
            var javascript = "var postForm=document.createElement('FORM');"
            javascript.append("postForm.name='postForm';")
            javascript.append("postForm.method='POST';")
            javascript.append("postForm.id='postFormId';")
            
            javascript.append("postForm.action='\(url)';")
            javascript.append("document.body.appendChild(postForm);")
            
            if body != nil {
                var i: Int = 0
                body?.keys.forEach({ keyValue in
                    if let data = body?[keyValue] {
                        
                        javascript.append("var inputData\(i)=document.createElement('INPUT');")
                        javascript.append("inputData\(i).type='HIDDEN';")
                        javascript.append("inputData\(i).name='\(keyValue)';")
                        javascript.append("inputData\(i).value='\(data)';")
                        javascript.append("postForm.appendChild(inputData\(i));")
                        
                        i += 1
                    }
                })
            }
            else {
                javascript.append("var inputData=document.createElement('INPUT');")
                javascript.append("inputData.type='HIDDEN';")
                javascript.append("inputData.value='\(bodyText ?? "")';")
                javascript.append("postForm.appendChild(inputData);")
            }

            javascript.append("document.getElementById('postFormId').submit();")
            
            debugPrint("javascript : \(javascript)")
            //        self.evaluateJavaScript(javascript) { (result, error) in }
            self.evaluateJavaScript(javascript, completionHandler: { result, error in
//                debugPrint("error : \(error)")
            })
        }
        else {
            
            var data = ""
            
            if let body = body {
                
                data = "?"
                var i: Int = 0
                for key in body.keys {
                    
                    i += 1
                    data.append("\(key)=\(body[key]!)")
                    
                    if body.keys.count > i {
                        
                        data.append("&")
                    }
                }
            }
            
            if let url = self.getUrl(url.appending(data)) {
                
                
                let request = URLRequest(url: url, cachePolicy: (ignoreCache ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy), timeoutInterval: TimeInterval(20))
                
                if let navigation:WKNavigation = self.load(request) { // 정확한 역할 찾아보기
                    
                    debugPrint("\(navigation)");
                }
            }
        }
    }
    
    private func getUrl(_ url: String, urlEncoding: Bool = true) -> URL? {
        
        if urlEncoding {
            var requestUrlText: String = ""

            if(url.hasPrefix("http") == false ) {

                requestUrlText = requestUrlText.appending(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! )
            } else {

                requestUrlText = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
            }

            let requestUrl = URL(string: requestUrlText)
            return requestUrl
        } else {
            let requestUrl = URL(string: url)
            return requestUrl
        }
    }
    
    var firstCallUrl: String?
    public func requestUrl(requestUrl: String, ignoreCache: Bool = false, urlEncoding: Bool = true) {
        
        guard let url = self.getUrl(requestUrl, urlEncoding: urlEncoding) else {
            return
        }
        
        self.firstCallUrl = url.absoluteString
        
        var request = URLRequest(url: url, cachePolicy: (ignoreCache ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy) , timeoutInterval: self.networkTimeout)
        request.httpShouldHandleCookies = true
        
        request.allHTTPHeaderFields = [:]
        
        _ = self.load(request)
        
    }
    
    /** cookie 동기화 */
    public func syncCookie(_ url: URL, allHeaderFields: [String: String] ) {
        
        let tmpCookies = HTTPCookie.cookies(withResponseHeaderFields: allHeaderFields, for: url)
        
        tmpCookies.forEach({cookie in
            HTTPCookieStorage.shared.setCookie(cookie)
        })
        
    }
    
    //MARK:- Script Observer
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "observe" {
            
        }
        
        debugPrint("\(#function)")
    }
    
    public func addScriptObserver() {
        
        self.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        self.configuration.userContentController.add(LeakAvoider(delegate: self), name: CustomWKWebView.ScriptHandler)
        self.configuration.userContentController.add(LeakAvoider(delegate: self), name: CustomWKWebView.ScriptHandler2)
        self.configuration.userContentController.add(LeakAvoider(delegate: self), name: CustomWKWebView.ScriptHandler3)
    }
    
    public func removeScriptHandler() {
        
        for webView in self.erCreatedWKWebViews {
            
            webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler)
            webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler2)
            webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler3)
            webView.configuration.userContentController.removeAllUserScripts()
        }
    }
    
    public func removeLastScriptHandler() {
        
        if let webView = self.erCreatedWKWebViews.last {
            
            webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler)
            webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler2)
            webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler3)
            webView.configuration.userContentController.removeAllUserScripts()
        }
    }
    
    //MARK: - WKwebview delegate
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.webviewDelegate?.startWebViewIndigator?()
        self.webviewDelegate?.webViewLoadingStart?(self)
        
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { result, error in
            guard let agent = result as? String else {
                return
            }
            
            webView.customUserAgent = agent
        })
    }
    
    
    func webViewDidClose(_ webView: WKWebView) {
        
        if self.erCreatedWKWebViews.count > 0 {
            self.removeLastScriptHandler()
            self.erCreatedWKWebViews.removeLast()
        }
        
        webView.removeFromSuperview()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler2)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: CustomWKWebView.ScriptHandler3)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        debugPrint("webView.url : \(webView.url?.absoluteString ?? "didReceiveServerRedirectForProvisionalNavigation url")")
    }
    
    /// WebPage에서 넘어온 데이터 확인하는 메소드
    ///
    /// - Parameter callUrl: 호출 URL
    /// - Returns: true  <- 일반적인 WebPage 호출, false <- WebPage와 앱간의 통신
    public func isHttpRequestUrlFromWebView(callUrl:URL?) -> Bool {
//        debugPrint("isHttpRequestUrlFromWebView callUrl : \(callUrl)")
        if( callUrl?.absoluteString.hasPrefix("about:blank") )! {
            
            return false;
        } else if( callUrl?.absoluteString.hasPrefix("http://itunes"))! {
            
            DispatchQueue.main.async {[weak self] in
                
                self?.progressBar?.isHidden = true
                if let url = callUrl {
                    UIApplication.shared.open(url, completionHandler: nil)
                }
            }
            
            return false
        } else if (callUrl?.scheme != "http" && callUrl?.scheme != "https") {
            
            self.callOtherScheme = callUrl
            
            self.webviewDelegate?.stopWebViewIndigator?()
            
            UIApplication.shared.open(callUrl!, completionHandler: { _ in
                
                DispatchQueue.main.async {[weak self] in
                    self?.progressBar?.isHidden = true
                    self?.webviewDelegate?.callOtherApp?()
                }
                
            })
            
            return self.webviewDelegate?.isHttpRequestUrl(callUrl: callUrl) ?? false
        } else {
            
            return self.webviewDelegate?.isHttpRequestUrl(callUrl: callUrl) ?? true
        }
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
        if #available(iOS 14.5, *) {
            
            if navigationAction.shouldPerformDownload {
                debugPrint("###")
                decisionHandler(.download, preferences)
                return
            }
        } else {
            
            if self.isHttpRequestUrlFromWebView(callUrl: navigationAction.request.url) {

                if  let url = navigationAction.request.url,
                    let allHeaderFields = navigationAction.request.allHTTPHeaderFields {

                    if self == webView {
                        self.pushUrlStack(url)
                    }
                    
                    self.syncCookie(url, allHeaderFields: allHeaderFields)
                }

                decisionHandler(.allow, preferences)
            } else {
                
                let urlText = String(describing: navigationAction.request.url?.absoluteString)
                
                if urlText.hasPrefix("data:image/png;base64") == true {
                    
                    if #available(iOS 14.5, *) {
                        decisionHandler(.download, preferences)
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    
                    decisionHandler(.cancel, preferences)
                }
                
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
    
        if navigationResponse.canShowMIMEType {
            if  let urlResponse = navigationResponse.response as? HTTPURLResponse,
                let url       = urlResponse.url,
                let allHeaderFields = urlResponse.allHeaderFields as? [String : String] {

                self.syncCookie(url, allHeaderFields: allHeaderFields)
            }
            
            decisionHandler(.allow)
        } else {
            if #available(iOS 14.5, *) {
                decisionHandler(.download)
            } else {
                // Fallback on earlier versions
                decisionHandler(.allow)
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let userController = WKUserContentController()
        // 화면에 보여지기 위해 addSubView 를 하므로 window.close() 시에 remove view 를 하도록 아래 소스를 document 시작시점에 inject 한다.
        let injectionScript = "var originalWindowClose=window.close;window.close=function(){var iframe=document.createElement('IFRAME');iframe.setAttribute('src','back://'),document.documentElement.appendChild(iframe);originalWindowClose.call(window)};"
        
        let userScript = WKUserScript(source: injectionScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        
        userController.addUserScript(userScript)
        
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.userContentController = userController
        configuration.processPool = webView.configuration.processPool //
        
        var newWebView: CustomWKWebView!
        
        newWebView = CustomWKWebView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), configuration: configuration)
        
        newWebView.closeWebView = {[unowned self] in
            self.closeWebView?()
        }
        
        newWebView.initWKWebView()
        self.addSubview(newWebView)
        
        self.erCreatedWKWebViews.append(newWebView);// 포함된 viewcontroller 가 dealloc 되기 전까지 참조를 유지 => 한번 생성된 window 를 다시 띄우는 경우 다시 create 를 타지 않기 때문에 remove view 를 해버리면 newWebView 가 dealloc 되므로
        
        debugPrint("self.erCreatedWKWebViews : \(self.erCreatedWKWebViews)")
        newWebView.alpha = 1.0 // 마지막 값을 설정하고 애니메이션 시작

        CATransaction.begin()

        CATransaction.setCompletionBlock { // 완료시 호출.
            newWebView.alpha = 1.0
        }

        let animationFadeIn:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")

        animationFadeIn.duration = 0.5
        animationFadeIn.values   = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        animationFadeIn.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        
        newWebView.layer.add(animationFadeIn, forKey: "opacity")

        CATransaction.commit()
        
        return newWebView;
    }
    
    //MARK: - alert Handler
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        
        self.webviewDelegate?.stopWebViewIndigator?()
        
        GlobalAlertViewModel.shared.showAlert(message: message, confirmBtn: AlertBtnModel(title: "확인", action: {
            completionHandler()
        }))
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void)
    {
        self.webviewDelegate?.stopWebViewIndigator?()
        
        GlobalAlertViewModel.shared.showAlert(message: message, confirmBtn: AlertBtnModel(title: "확인", action: {
            completionHandler(true)
        }), cancelBtn: AlertBtnModel(title: "취소", action: {
            completionHandler(false)
        }))
    }
    
    //MARK: - navigation
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        let localError = error as NSError
        var isExceptionScheme  = false // 예외 스키마 허용 여부
        
        let erExceptionSchemes = ["tel:", "mailto:", "callto:", "facetime:", "sms:" ]
        
        for scheme in erExceptionSchemes {
            
            if self.callOtherScheme?.scheme == scheme {
                
                isExceptionScheme = true
                break
            }
        }
        
        if  localError.code == -1002 && isExceptionScheme { // tel, mailto:
            
            self.webviewDelegate?.loadingFinish?()
        }
        else {
            
            if localError.code != -999 {
                
                self.webviewDelegate?.stopWebViewIndigator?()
                self.webviewDelegate?.taskWithError?(error: localError)
            }
        }
        
        
        if(localError.code == NSURLErrorTimedOut) {
            
        }
    }
    
    /**! @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        self.webviewDelegate?.stopWebViewIndigator?()
        self.webviewDelegate?.webViewLoaded?(self)
        self.webviewDelegate?.loadingFinish?()
        self.loadingFinish?()
        if let url = self.putUrlStack() {
            
            print("url : \(url)")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.webviewDelegate?.stopWebViewIndigator?()
        
        self.progressBar?.isHidden = true
        self.webviewDelegate?.loadingFinish?()
        self.loadingFinish?()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        let tmpError = error as NSError
        
        if tmpError.code == NSURLErrorNotConnectedToInternet {
            debugPrint("NSURLErrorNotConnectedToInternet");
            return
        }
        
        self.webviewDelegate?.stopWebViewIndigator?()
        
        if self.webviewDelegate != nil {
            
            self.webviewDelegate?.taskWithError?(error: tmpError)
            self.webviewDelegate?.webViewLoaded?(self)
        } else {
            
            self.taskWithError( tmpError)
        }
        
        self.webviewDelegate?.loadingFinish?()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return
        }
        
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
    
    //MARK: - Error Process Part
//    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
//        #if DEBUG
//        CustomToastMessage.shared.showMessage("webViewWebContentProcessDidTerminate")
//        #endif
//    }
    
    public func taskWithError(_ error: NSError) {
        
        switch  error.code {
        case NSURLErrorTimedOut : // time out
            
            break;
        case NSURLErrorCannotFindHost :
            
//            CustomToastMessage.shared.showMessage("kCFURLErrorCannotFindHost");
            break;
        case NSURLErrorNotConnectedToInternet :
            
//            CustomToastMessage.shared.showMessage("NSURLErrorNotConnectedToInternet");
            break;
        default:
            break;
        }
    }
    
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
    }
    
}

extension CustomWKWebView: WKDownloadDelegate {
    
    @available(iOS 14.5, *)
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
    
    @available(iOS 14.5, *)
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent(suggestedFilename)
        
        completionHandler(url)
        
        if let data = response.url?.absoluteString.components(separatedBy: ",").last, let imgData = Data(base64Encoded: data), let img = UIImage(data: imgData) {
            
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(CustomWKWebView.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        PHPhotoLibrary.requestAuthorization{ status in
            
        }
    }
    
    @available(iOS 14.5, *)
    func downloadDidFinish(_ download: WKDownload) {
        
    }
    
    @available(iOS 14.5, *)
    func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        print("download error : \(error)")
    }
}
