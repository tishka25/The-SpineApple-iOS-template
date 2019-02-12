//
//  WKWebViewHelpers.swift
//  The SpineApple
//
//  Created by Teodor Stanishev on 12.02.19.
//  Copyright © 2019 THESPINEAPPLE. All rights reserved.
//

import Foundation
import WebKit
import SafariServices

class WKWebViewHelpers{
    public static func loadWebView(url:URL , webView:WKWebView , delegate:WKNavigationDelegate){
        let myRequest = URLRequest(url: url)
        webView.navigationDelegate = delegate
        webView.scrollView.bounces = false;
        webView.load(myRequest)
    }
    public static func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
}
