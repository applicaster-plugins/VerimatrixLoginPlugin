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

let baseApi = "https://idp.securetve.com/rest/1.0"

@objc class VerimatrixLoginApi: NSObject {
    
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
    func getProviders(completion: @escaping ((_ names: [String]?, _ possibleIdps: [String]?) -> Void)){
        let apiName = "\(baseApi)/\(platformId ?? "urn:ntitlemeintegration:com:sp:staging")/\(ApiType.getProviders.rawValue)"
        let url = URL(string: apiName)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        makeRequest(request: request) { (responseJson, response, error) in
            if(response?.statusCode == 200){
                var names : [String] = []
                var possibleIdps : [String] = []
                if let json = responseJson as? [String:Any] {
                    if let providers = json["possible_idps"] as? [String:[String:Any]]{
                        providers.forEach({ (model) in
                            possibleIdps.append(model.key)
                            if let providerName = model.value["name"] as? String{
                                names.append(providerName)
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
                completion(names,possibleIdps)
            }else{
                if let delegate = self.delegate{
                    delegate.errorOnApi()
                }
            }
        }
    }
    
    
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
    
    func getUserToken( completion: @escaping ((_ success: Bool) -> Void)){
        let resourceId = configuration?["resource_id"] as? String ?? "WGNA"
        let apiName = "\(baseApi)/\(platformId!)/\(ApiType.resourceId.rawValue)/\(resourceId)?format=json&responsefield=aisrespons"
        let url = URL(string: apiName)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        makeRequest(request: request) { (responseJson, response, error) in
            if(response?.statusCode == 200){
                if let jsonRespone = responseJson as? [String:Any]{
                    if let token = jsonRespone["security_token"] as? String{
                       CredentialsManager.saveToken(token: token)
                       completion(true)
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
    
    func saveCookie(url: String){
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
