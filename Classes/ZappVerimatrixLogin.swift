//
//  ZappDigicelLogin.swift
//  CleengPluginExample
//
//  Created by Miri on 12/07/2019.
//  Copyright © 2018 Applicaster. All rights reserved.
//

import Foundation
import ZappPlugins
import ZappLoginPluginsSDK



@objc public class ZappVerimatrixLogin : NSObject {
    
   
    /// Plugin configuration json. See plugin manifest for the list of available configuration flags
    public var configurationJSON: NSDictionary?
    
    private var navigationController: UINavigationController? = nil
    
    fileprivate var loginCompletion:(((_ status: ZPLoginOperationStatus) -> Void))?

    public required override init() {
        super.init()
    }
    
    public required init(configurationJSON: NSDictionary?) {
        super.init()
    }
    
    //MARK: - ZPLoginProviderUserDataProtocol
    
    /// A map of closures to call on verify completion
    private var verifyCalls: [String:((Bool) -> ())] = [:]
    
   
    /**
     `ZPLoginProviderUserDataProtocol` api. Call this to present UI to let user make login (if needed) and IAP purchase (if needed).
     */
    public func login(_ additionalParameters: [String : Any]?, completion: @escaping ((ZPLoginOperationStatus) -> Void)) {
        
    }
    
    /**
     `ZPLoginProviderUserDataProtocol` api. Call this to logout from Cleeng.
     */
    public func logout(_ completion: @escaping ((ZPLoginOperationStatus) -> Void)) {
      
    }
    
    public func isAuthenticated() -> Bool {
        return false
    }
    
    /**
     `ZPLoginProviderUserDataProtocol` api. Check if there currently UI presented to make login or IAP purchase for an item
     */
    public func isPerformingAuthorizationFlow() -> Bool {
        return false
    }
    
}
