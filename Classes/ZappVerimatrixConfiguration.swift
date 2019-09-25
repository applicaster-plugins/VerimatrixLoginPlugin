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
        case actionBtnTitle = "provider_screen_action_button_text"
        case actionBtnTitleColor = "provider_action_button_text_color"
        case actionBtnTitleSize = "provider_action_button_text_size"
        case actionBtnTitleFont = "provider_action_button_text_font"
        case background = "provider_screen_background"
        case titleColor = "provider_screen_title_color"
        case titleSize = "provider_screen_title_size"
        case titleFont = "provider_screen_title_font"
        case pickerDeafultColor = "provider_default_color"
        case pickerDeafultFont = "provider_default_font"
        case pickerSelectedColor = "provider_selected_color"
        case pickerSelectedSize = "provider_selected_size"
        case pickerSelectedFont = "provider_selected_font"
        case loginErrorMessage = "login_general_error"
    }
    
    public enum AssetKey : String{
        case closeBtn = "provider_screen_close_btn"
        case logoImage = "provider_screen_logo"
        case loginBtn = "provider_action_button_asset"
    }

    public func localizedString(for key: ConfigKey, defaultString: String? = nil) -> String? {
        return (configuration[key.rawValue] as? String) ?? defaultString
    }
}

