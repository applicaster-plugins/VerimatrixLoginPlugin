//
//  VerimatrixLoginApi.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 13/08/2019.
//

import Foundation
import ZappPlugins
import ZappLoginPluginsSDK
import ApplicasterSDK
import os

let baseApi = "https://idp.securetve.com/rest/1.0"

@objc class VerimatrixLoginApi: NSObject {
    var getUserTokenRetry = 0
    var configuration: NSDictionary?
    var platformId: String?
    var delegate: VerimatrixBaseProtocol?

    init(config: NSDictionary?) {
        self.configuration = config
        if let platformId = config?[ZappVerimatrixConfiguration.ConfigKey.WGNPlatformId.rawValue] as? String{
            self.platformId = platformId
        }
    }
    
    // get a list of providers for the login screen
    func getProviders(completion: @escaping ((_ providers: [Providers]?) -> Void)){
        let apiName = "\(baseApi)/\(platformId ?? "urn:ntitlemeintegration:com:sp:staging")/\(ApiType.getProviders.rawValue)"
        let url = URL(string: apiName)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        makeRequest(request: request) { (responseJson, response, error) in
            if(response?.statusCode == 200){
                var allProviders = [Providers]()
                if let json = responseJson as? [String:Any] {
                    if let providers = json["possible_idps"] as? [String:[String:Any]]{
                        providers.forEach({ (model) in
                            if let providerName = model.value["display_name"] as? String{
                                allProviders.append(Providers(name: providerName, idp: model.key))
                            }
                        })
                    }else{
                        if let delegate = self.delegate{
                            delegate.errorOnApi()
                            return
                        }
                    }
                }else{
                    if let delegate = self.delegate{
                        delegate.errorOnApi()
                        return
                    }
                }
                completion(allProviders)
            }else{
                if let delegate = self.delegate{
                    delegate.errorOnApi()
                }
            }
        }
    }
    
    // login flaw to get the token
    func startLoginFlaw(url: String, completion: @escaping ((_ success: Bool) -> Void)){
        let requestUrl = URL(string: url)!
        let request = NSMutableURLRequest(url: requestUrl)
        request.httpMethod = "GET"
        print(request.allHTTPHeaderFields ?? "none")
        makeRequest(request: request) { (responseJson, response, error) in
            if(response?.statusCode == 200){
                if let jsonRespone = responseJson as? [String:Any]{
                    if let authenticated = jsonRespone["authenticated"] as? Bool{
                        if(authenticated){
                            
                            self.getUserToken(completion: completion)
                        }else{
                            completion(false)
                        }
                    }else{
                        completion(false)
                    }
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
    }
    
    //get user token api
    func getUserToken( completion: @escaping ((_ success: Bool) -> Void)){
        let resourceId = configuration?["resource_id"] as? String ?? "WGNA"
        let apiName = "\(baseApi)/\(platformId!)/\(ApiType.resourceId.rawValue)/\(resourceId)?format=json&responsefield=aisrespons"
        os_log("Request url %s", apiName)
        let url = URL(string: apiName)!
        let request = NSMutableURLRequest(url: url)
        let cookis = HTTPCookie.requestHeaderFields(with: readCookie(forURL: url)).description
        os_log("Request cookies %s", cookis)
        request.httpMethod = "GET"
        print(request.allHTTPHeaderFields ?? "none")
        makeRequest(request: request) { (responseJson, response, error) in
            if(response?.statusCode == 200){
                if let jsonRespone = responseJson as? [String:Any]{
                    if let token = jsonRespone["security_token"] as? String{
                       CredentialsManager.saveToken(token: token)
                       completion(true)
                    }else{
                        os_log("failed with response: %s", jsonRespone.description)
                        self.getUserTokenRetry += 1
                        if(self.getUserTokenRetry == 5) {
                            self.getUserTokenRetry = 0
                            completion(false)
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.getUserToken(completion: completion)
                            }
                        }
                    }
                }else{
                  completion(false)
                }
            }else{
                completion(false)
            }
        }
    }
    
    //trying to get user token in every app launch
    func trySilentLogin(completion: @escaping ((_ success: Bool) -> Void)){
        let apiName = "\(baseApi)/\(platformId!)/\(ApiType.slientLogin.rawValue)"
        let url = URL(string: apiName)!
        let request = NSMutableURLRequest(url: url)
        let headers = HTTPCookie.requestHeaderFields(with: readCookie(forURL: url))
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        makeRequest(request: request) { (responseJson, response, error) in
            if (response?.statusCode == 200){
                if let jsonRespone = responseJson as? [String:Any]{
                    if let authenticated = jsonRespone["authenticated"] as? Bool{
                        if(authenticated){
                            self.getUserToken(completion: completion)
                        }else{
                            completion(false)
                        }
                    }else{
                        completion(false)
                    }
                }else{
                    completion(false)
                }
            }else{
               completion(false)
            }
        }
    }
    
    //get full url for webview login
    func urlForResource(resource: String) -> String{
       let url = "\(baseApi)/\(platformId ?? "urn:ntitlemeintegration:com:sp:staging")/init/\(resource)"
       return url
    }
    
    func saveCookies(url: String){
        let url = URL(string: url)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        makeRequest(request: request) { (responseJson, response, error) in
            if let httpResponse = response, let fields = httpResponse.allHeaderFields as? [String:String] {
                let responseCookies = HTTPCookie.cookies(withResponseHeaderFields: fields , for: url)
                self.deleteCookies(forURL: url)
                self.storeCookies(responseCookies, forURL: url)
            }
        }
    }
    
    func deleteCookies(forURL url: URL) {
        let cookieStorage = HTTPCookieStorage.shared
        
        for cookie in readCookie(forURL: url) {
            cookieStorage.deleteCookie(cookie)
        }
    }
    
    func storeCookies(_ cookies: [HTTPCookie], forURL url: URL) {
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.setCookies(cookies,
                                 for: url,
                                 mainDocumentURL: nil)
    }
    
    func readCookie(forURL url: URL) -> [HTTPCookie] {
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: url) ?? []
        return cookies
    }
    
    // network request for api
    private func makeRequest(request: NSMutableURLRequest, completion: @escaping ((_ result: Any?, _ httpResponse: HTTPURLResponse?, _ error: Error?) -> Void)) {
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data , let json = (try? JSONSerialization.jsonObject(with: data, options: [])) else {
                    completion(nil, (response as? HTTPURLResponse), error)
                    return
            }
            
            print("Response: \(json)")
            if let json = json as? [String:Any]  {
                DispatchQueue.onMain {
                    completion(json, (response as? HTTPURLResponse), error)
                }
            }
            else {
                DispatchQueue.onMain {
                    completion(json, (response as? HTTPURLResponse), error)
                }
            }
        }
        task.resume()
    }
    
    public enum ApiType: String{
        case getProviders = "chooser"
        case resourceId = "identity/resourceAccess"
        case slientLogin = "bounce?format=json&responsefield=aisresponse"
    }
}

internal extension DispatchQueue {
    static func onMain(_ block: @escaping (() -> Void)) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
