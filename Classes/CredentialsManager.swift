//
//  CredentialsManager.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 18/08/2019.
//

import Foundation

@objc class CredentialsManager: NSObject{
    
    //save token or id or any info to user defaults
    public static func saveCredential(object: String , for key: CredentialType){
        UserDefaults.standard.set(object, forKey: key.rawValue)
    }
    
    //get token or id or any info from user defaults
    public static func getCredential(key: CredentialType) -> String{
        if let Credential = UserDefaults.standard.string(forKey: key.rawValue){
            return Credential
        }else{
            return ""
        }
    }
    
    public enum CredentialType: String{
        case Code = "code"
    }
}
