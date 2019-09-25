//
//  CredentialsManager.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 18/08/2019.
//

import Foundation

@objc class CredentialsManager: NSObject{
    
    //save token or id or any info to user defaults
    public static func saveToken(token: String){
        UserDefaults.standard.set(token, forKey: CredentialType.Token.rawValue)
    }
    
    //get token or id or any info from user defaults
    public static func getToken() -> String{
        if let Credential = UserDefaults.standard.string(forKey: CredentialType.Token.rawValue){
            return Credential
        }else{
            return ""
        }
    }
    
    public enum CredentialType: String{
        case Token = "code"
    }
}
