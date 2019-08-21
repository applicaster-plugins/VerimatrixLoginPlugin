//
//  VerimatrixWebViewController.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 18/08/2019.
//



import Foundation
import ApplicasterSDK
import ZappPlugins
import ZappLoginPluginsSDK

let kCallbackURL = "https://idp.securetve.com/idpconsumer/oauth2";

public protocol VerimatrixRedirectUriProtocol {
    func handleRedirectUriWith(params: [String : Any]?)
}

//handling redirect url from webview login
class VerimatrixWebViewController: APTimedWebViewController {
    
    public var redirectUriDelegate: VerimatrixRedirectUriProtocol!
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
       
        let request = navigationAction.request
        guard let urlString = request.url?.absoluteString,
            (urlString.range(of: kCallbackURL) != nil),
            let requestUrl = request.url,
            let queryDict = (requestUrl as NSURL).queryDictionary(),
            let code = queryDict["code"] as? String else {
                return
        }
        self.redirectUriDelegate.handleRedirectUriWith(params: ["code" : code])
    }
}
