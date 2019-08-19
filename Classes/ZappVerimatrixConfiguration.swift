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
    
    public enum ConfigKey : String {
        case startOnLaunch = "display_on_launch"
        case WGNPlatformId = "WGN_platform_id"
        case iOSAssets = "ios_assets_bundle"
        case providersScreenTitle = "provider_screen_title_text"
        case providersScreenActionBtnTitle = "provider_screen_action_button_text"
    }
    
    public enum AssetKey : String{
        case closeBtn = "provider_screen_close_btn"
        case logoImage = "provider_screen_logo"
        case loginBtn = "provider_action_button_asset"
    }
    
    public enum StyleKey : String{
        case background = "provider_screen_background"
        case gradientOverlay = "provider_text_gradient_overlay"
        case defaultPickerText = "provider_default_text"
        case lineSeparator = "provider_separator"
        case pickerSelectedText = "provider_selected_text"
        
    }
    
}

