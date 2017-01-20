//
//  WebViewController.swift
//  Recipy
//
//  Created by Amaury Vidal on 20/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

/// Simple webview controller without web controls
class WebViewController: UIViewController {
    
    @IBOutlet var webView : UIWebView?
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRequest()
    }
    
    func loadRequest() {
        if let url = url {
            print("loading request")
            let request = URLRequest(url: url)
            webView?.loadRequest(request)
        }
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
