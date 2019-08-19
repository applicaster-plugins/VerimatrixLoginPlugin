//
//  CredentialsManager.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 18/08/2019.
//

import Foundation

@objc class CredentialsManager: NSObject{
    
    public static func saveCredential(object: String , for key: CredentialType){
        UserDefaults.standard.set(object, forKey: key.rawValue)
    }
    
    public static func getCredential(key: CredentialType){
        UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    public enum CredentialType: String{
        case Code = "code"
    }
}
