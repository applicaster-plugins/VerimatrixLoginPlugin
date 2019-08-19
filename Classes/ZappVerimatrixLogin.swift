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



@objc public class ZappVerimatrixLogin : NSObject ,ZPAppLoadingHookProtocol, ZPLoginProviderProtocol, VerimatrixBaseProtocol, VerimatrixRedirectUriProtocol{
    
    public var configurationJSON: NSDictionary?

    public var configurationManger: ZappVerimatrixConfiguration?
    
    private var navigationController: UINavigationController? = nil
    
    private var loginViewController: VerimatrixLoginViewController!
    
    private var api: VerimatrixLoginApi?
    
    fileprivate var loginCompletion:(((_ status: ZPLoginOperationStatus) -> Void))?

    public required override init() {
        super.init()
    }
    
    public required init(configurationJSON: NSDictionary?) {
        super.init()
        self.configurationJSON = configurationJSON
        api = VerimatrixLoginApi(config: configurationJSON)
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
    
    public func presentLoginScreen(){
        let bundle = Bundle.init(for: type(of: self))
        loginViewController = VerimatrixLoginViewController(nibName: "VerimatrixLoginViewController", bundle: bundle)
        loginViewController.delegate = self
        loginViewController.configurationJson = self.configurationJSON
        if let screenModel = ZAAppConnector.sharedInstance().layoutComponentsDelegate.componentsManagerGetScreenComponentforPluginID(pluginID: "WGNLoginPlugin"), screenModel.isPluginScreen() , let style = screenModel.style{
            let test = style.object
        }
        navigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let navController = navigationController{
            api?.getProviders(completion: { (ids) in
                if (ids?.count != 0){
                    self.loginViewController.providersName = ids
                    APApplicasterController.sharedInstance().rootViewController.topmostModal().present(navController,
                                                                                                       animated: true) {
                    }
                }
            })
           
        }
    }
    
    public func getUserToken() -> String {
        return "test"
    }
    
    public func providerSelected(provider: String) {
        if let url = api?.urlForResource(resource: provider){
             let bundle = Bundle.init(for: type(of: self))
             let webview = VerimatrixWebViewController(url: URL(string: url))
             webview?.redirectUriDelegate = self
             let webViewloginController = VerimatrixWebViewLoginController(nibName: "VerimatrixWebViewLoginController", bundle: bundle)
             webViewloginController.webViewController = webview
             loginViewController.present(webViewloginController,animated: true){
                webViewloginController.addChildViewController(webViewloginController.webViewController, to: webViewloginController.webViewContainer)
                webview?.loadTargetURL()
            }
        }
    }
    
    public func handleRedirectUriWith(params: [String : Any]?) {
        if let code = params?["code"] as? String {
            closeBtnDidPress()
        }
    }
    
    public func closeBtnDidPress() {
        if let vc = navigationController?.presentingViewController{
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
}
