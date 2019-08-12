//
// ZappVerimatrixConfiguration.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 12/08/2019.
//

import Foundation

import UIKit
import ZappPlugins


public struct ZappVerimatrixConfiguration {
    
    private let configuration: [String:Any]
    
    public init(configuration: [String: Any]){
        self.configuration  = configuration
    }
    
}

public enum ConfigKey : String {
    case startOnLaunch = "display_on_launch"
}




