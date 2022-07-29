//
//  WebViewController.swift
//  Save Gift
//
//  Created by ukBook on 2022/07/22.
//

import Foundation
import UIKit
import WebKit


class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate{
    let helper : Helper = Helper()
    let serverURL = { () -> String in
        let url = Bundle.main.url(forResource: "Gift", withExtension: "plist")
        let dictionary = NSDictionary(contentsOf: url!)

        // 각 데이터 형에 맞도록 캐스팅 해줍니다.
        #if DEBUG
        var LocalURL = dictionary!["debugURL"] as? String
        #elseif RELEASE
        var LocalURL = dictionary!["releaseURL"] as? String
        #endif
        
        return LocalURL!
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    var strURL : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "\(serverURL()+strURL!)")
        let request = URLRequest(url: url!)
        
        navTitleInit()
        //self.webView?.allowsBackForwardNavigationGestures = true  //뒤로가기 제스쳐 허용
//        webView.configuration.preferences.javaScriptEnabled = true  //자바스크립트 활성화
        webView.load(request)
        webView.sizeToFit()
        webView.scrollView.delegate = self
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    func navTitleInit() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
//        let rightBarButton = UIBarButtonItem.init(title: "확인", style: .plain, target: self, action: #selector(self.actionA)) //Class.MethodName
//        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        if strURL == "/marketing/agree" {
            self.navigationItem.title = "마케팅 정보 수신 약관"
        }else {
            self.navigationItem.title = "개인정보 수집 및 이용 동의"
        }
        
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
