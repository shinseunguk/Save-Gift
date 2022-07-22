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
    let localUrl = "".getLocalURL()
    
    @IBOutlet weak var webView: WKWebView!
    
    var str : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "\(localUrl)/marketing/agree")
        let request = URLRequest(url: url!)
        //self.webView?.allowsBackForwardNavigationGestures = true  //뒤로가기 제스쳐 허용
//        webView.configuration.preferences.javaScriptEnabled = true  //자바스크립트 활성화
        webView.load(request)
        webView.sizeToFit()
        webView.scrollView.delegate = self
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
