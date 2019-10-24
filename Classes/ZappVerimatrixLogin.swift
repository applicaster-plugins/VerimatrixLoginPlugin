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
     `ZPLoginProviderUserDataProtocol` api. Call this to present UI to let user make login.
     */
    public func login(_ additionalParameters: [String : Any]?, completion: @escaping ((ZPLoginOperationStatus) -> Void)) {
        self.loginCompletion = completion
        self.presentLoginScreen()
    }
    
    /**
     `ZPLoginProviderUserDataProtocol` api.
     */
    public func logout(_ completion: @escaping ((ZPLoginOperationStatus) -> Void)) {
      
    }
    
    /**
     `ZPLoginProviderUserDataProtocol` api. Call this to check if item is locked
     */
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
        
        // if check box is checked so show login screen
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
            return
        }
        
        //try to get new token in each lunch. if failed: show login
        api?.trySilentLogin(completion: { (success) in
            if(!success){
                CredentialsManager.saveToken(token: "")
            }
        })
    }
    
    // present the login screen
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
    
    // get user token
    public func getUserToken() -> String {
        return CredentialsManager.getToken()
    }
    
    //when user choose a provider its open the webview
    public func providerSelected(provider: String) {
        if let url = api?.urlForResource(resource: provider){
             let webview = VerimatrixWebViewController(url: URL(string: url))
             webview?.redirectUriDelegate = self
             webview?.kCallbackURL = configurationJSON?["wgn_redirect_url"] as? String ?? "http://idp.securetve.com/saml2/assertionConsumer/"
             loginViewController.webViewVC = webview
             webview?.loadTargetURL()
        }
    }
    
    //handle the redirect url from the webview
    public func handleRedirectUriWith(url: String) {
        api?.startLoginFlaw(url: url, completion: { (success) in
            if(!success){
                self.errorOnApi()
            }else{
                self.closeOnlyLoginScreen {
                     self.loginCompletion?(.completedSuccessfully)
                }
            }
        })
    }
    
    func closeOnlyLoginScreen(completion: @escaping () -> ()){
        if  let vc = self.navigationController?.viewControllers.first{
            vc.dismiss(animated: true) {
                completion()
            }
        }
    }
    
    // close login webView screen if exists
    public func webviewCloseBtnDidPress() {
        if  let vc = self.navigationController?.viewControllers.first{
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
     // close login screen if exists
    public func closeBtnDidPress() {
        if let vc = navigationController?.presentingViewController{
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    // show error message if api request falied
    public func errorOnApi() {
            let message = configurationManger?.localizedString(for: .loginErrorMessage) ?? "Error, try again later"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (finish) in
            self.closeBtnDidPress()
        }))
            if let vc = self.navigationController?.viewControllers.first{
                vc.present(alert, animated: true, completion: nil)
            }else{
                APApplicasterController.sharedInstance().rootViewController.topmostModal().present(alert, animated: true)
            }
        }
}
