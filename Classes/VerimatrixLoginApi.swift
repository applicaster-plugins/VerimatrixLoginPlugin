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

let baseApi = "http://pdx-is.uat.ntitleme.net/rest/1.0"

@objc class VerimatrixLoginApi: NSObject {
    var configuration: NSDictionary?
    var platformId: String?
    var possibleIdps: [String] = []
    
    init(config: NSDictionary?) {
        self.configuration = config
        if let platformId = config?[ZappVerimatrixConfiguration.ConfigKey.WGNPlatformId.rawValue] as? String{
            self.platformId = platformId
        }
    }
    
     func getProviders(completion: @escaping ((_ result: [String]?) -> Void)){
        
        let apiName = "\(baseApi)/\(platformId ?? "")/\(ApiType.getProviders.rawValue)"
        let url = URL(string: apiName)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        makeRequest(request: request) { (responseJson, response, error) in
            var names : [String] = []
            if let json = responseJson as? [String:Any] {
                if let providers = json["possible_idps"] as? [String:[String:Any]]{
                    providers.forEach({ (model) in
                        self.possibleIdps.append(model.key)
                        if let providerName = model.value["display_name"] as? String{
                            names.append(providerName)
                        }
                    })
                }
            }
            completion(self.possibleIdps)
        }
    }
    
    func urlForResource(resource: String) -> String{
        let url = "\(baseApi)/\(platformId ?? "")/init/\(resource)"
        return url
    }
    

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
        case resourceAccess = "identity/resourceAccess"
        
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
