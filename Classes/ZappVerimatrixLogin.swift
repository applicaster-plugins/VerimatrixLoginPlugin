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
import ApplicasterSDK




@available(iOS 11.0, *)
@objc public class ZappVerimatrixLogin : NSObject ,ZPAppLoadingHookProtocol, ZPLoginProviderUserDataProtocol , ZPLoginProviderProtocol, VerimatrixBaseProtocol, VerimatrixRedirectUriProtocol{
    
    public var configurationJSON: NSDictionary?
    var configurationManger: ZappVerimatrixConfiguration?
    var navigationController: UINavigationController? = nil
    var loginViewController: VerimatrixLoginViewController!
    var api: VerimatrixLoginApi?
    fileprivate var loginCompletion:(((_ status: ZPLoginOperationStatus) -> Void))?

    public required override init() {
        super.init()
    }
    
    public required init(configurationJSON: NSDictionary?) {
        super.init()
        self.configurationJSON = configurationJSON
        api = VerimatrixLoginApi(config: configurationJSON)
        api?.delegate = self
    }
    
    /**
     `ZPLoginProviderUserDataProtocol` api. Call this to present UI to let user make login (if needed) and IAP purchase (if needed).
     */
    public func login(_ additionalParameters: [String : Any]?, completion: @escaping ((ZPLoginOperationStatus) -> Void)) {
        self.presentLoginScreen()
    }
    
    /**
     `ZPLoginProviderUserDataProtocol` api. Call this to logout from Cleeng.
     */
    public func logout(_ completion: @escaping ((ZPLoginOperationStatus) -> Void)) {
      
    }
    
    public func isUserComply(policies: [String : NSObject]) -> Bool {
        if let freeValue = policies["free"] as? Bool {
            if freeValue { return true}
        }
        
        if let freeValue = policies["free"] as? String {
            if (freeValue == "true") {return true}
            }
        
        return !CredentialsManager.getToken().isEmpty
        
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
    
    public func executeAfterAppRootPresentation(displayViewController: UIViewController?, completion: (() -> Void)?) {
        guard let startOnLaunch = configurationJSON?[ZappVerimatrixConfiguration.ConfigKey.startOnLaunch.rawValue] else {
            return
        }
        
        api?.trySilentLogin(completion: { (success) in
            if(!success){
                CredentialsManager.saveToken(token: "")
                self.login(nil, completion: { (status) in
                    
                })
                return
            }
        })

        
        var presentLogin = false
        if let flag = startOnLaunch as? Bool {
            presentLogin = flag
        } else if let num = startOnLaunch as? Int {
            presentLogin = (num == 1)
        } else if let str = startOnLaunch as? String {
            presentLogin = (str == "1")
        }
        
        
        if(presentLogin){
            self.login(nil) { (status) in
            }
        }
    }
    
     func presentLoginScreen(){
        let bundle = Bundle.init(for: type(of: self))
        loginViewController = VerimatrixLoginViewController(nibName: "VerimatrixLoginViewController", bundle: bundle)
        loginViewController.delegate = self
        loginViewController.configurationJson = self.configurationJSON as? [String : Any]
        navigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let navController = navigationController{
            api?.getProviders(completion: { (displayNames , providersIdps)  in
                if (providersIdps?.count != 0){
                    self.loginViewController.providersName = displayNames
                    self.loginViewController.providersIdp  = providersIdps
                    APApplicasterController.sharedInstance().rootViewController.topmostModal().present(navController,
                                                                                                       animated: true) {
                    }
                }
            })
        }
    }
    
    public func getUserToken() -> String {
        return CredentialsManager.getToken()
    }
    
    public func providerSelected(provider: String) {
        if let url = api?.urlForResource(resource: provider){
             let webview = VerimatrixWebViewController(url: URL(string: url))
             webview?.redirectUriDelegate = self
             webview?.kCallbackURL = configurationJSON?["wgn_redirect_url"] as? String ?? "http://idp.securetve.com/saml2/assertionConsumer/"
             loginViewController.webViewVC = webview
             webview?.loadTargetURL()
        }
    }
    
    public func handleRedirectUriWith(url: String) {
        api?.startLoginFlaw(url: url, completion: { (success) in
            if(!success){
                self.errorOnApi()
            }
        })
    }
    
    public func webviewCloseBtnDidPress() {
        if  let vc = self.navigationController?.viewControllers.first{
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    public func closeBtnDidPress() {
        if let vc = navigationController?.presentingViewController{
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    public func errorOnApi() {
            let message = configurationManger?.localizedString(for: .loginErrorMessage)
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            if let vc = self.navigationController?.viewControllers.first{
                vc.present(alert, animated: true, completion: nil)
            }else{
                APApplicasterController.sharedInstance().rootViewController.topmostModal().present(alert, animated: true)
            }
        }
    
}
