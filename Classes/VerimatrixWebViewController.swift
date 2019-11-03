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

public protocol VerimatrixRedirectUriProtocol {
    func handleRedirectUriWith(url: String)
}

//handling redirect url from webview login
@available(iOS 11.0, *)
class VerimatrixWebViewController: APTimedWebViewController {
    
    public var kCallbackURL: String!
    public var kCallbackURLHTTPS: String!
    public var redirectUriDelegate: VerimatrixRedirectUriProtocol!

    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let urlString = webView.url?.absoluteString{
            if(((urlString.starts(with: kCallbackURLHTTPS))) || (urlString.starts(with: kCallbackURL))){
                webView.getCookies(for: urlString) { (cookie) in
                    if(!urlString.containsIgnoringCase(find: "SAMLRequest")){
                          self.redirectUriDelegate.handleRedirectUriWith(url: "")
                    }
                }
            }
        }
    }
    
    
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        super.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        
        let request = navigationAction.request
        if let urlString = request.url?.absoluteString{
            if((urlString.starts(with: kCallbackURLHTTPS)) || (urlString.starts(with: kCallbackURL))){
                webView.getCookies(for: urlString) { (cookie) in
                    if(urlString.containsIgnoringCase(find: "SAMLRequest")){
                         self.redirectUriDelegate.handleRedirectUriWith(url: urlString)
                    }
                }
            }
        }
    }
}

@available(iOS 11.0, *)
extension WKWebView {
    
    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }
    
    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            
            let cookieStorage = HTTPCookieStorage.shared
            cookieStorage.setCookies(cookies,
                                     for: URL(string: domain!),
                                     mainDocumentURL: nil)
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}
