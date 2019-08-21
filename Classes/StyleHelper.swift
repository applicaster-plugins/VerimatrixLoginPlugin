//
//  StyleHelper.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 15/08/2019.
//

import Foundation

@objc class StyleHelper : NSObject{
    
    //set color, font and size to label from plugin configuration
    public static func setLabelStyle(label: UILabel, colorForKey: ZappVerimatrixConfiguration.ConfigKey, fontSizeKey: ZappVerimatrixConfiguration.ConfigKey, fontNameKey: ZappVerimatrixConfiguration.ConfigKey, from dictionary:[String:Any]?){
        if let colorKey = dictionary?[colorForKey.rawValue] as? String, !colorKey.isEmptyOrWhitespace(){
            let color = UIColor(argbHexString: colorKey)
            label.textColor = color
        }
        
        if let fontSizeString = dictionary?[fontSizeKey.rawValue] as? String, let fontName = dictionary?[fontNameKey.rawValue] as? String
        , let fontSize = CGFloat(fontSizeString), let font = UIFont(name: fontName, size: CGFloat(fontSize)){
          label.font = font
        }
    }
    
    //set text to label from plugin configuration
    public static func setLabelText(label: UILabel, textKey: ZappVerimatrixConfiguration.ConfigKey, from dictionary:[String:Any]?){
        if let labelText = dictionary?[textKey.rawValue] as? String, !labelText.isEmptyOrWhitespace(){
            label.text = labelText
        }
    }
    
    //set color, font and size to button from plugin configuration
    public static func setButtonStyle(button: UIButton, colorForKey: ZappVerimatrixConfiguration.ConfigKey, fontSizeKey: ZappVerimatrixConfiguration.ConfigKey, fontNameKey: ZappVerimatrixConfiguration.ConfigKey, from dictionary:[String:Any]?){
        if let colorKey = dictionary?[colorForKey.rawValue] as? String, !colorKey.isEmptyOrWhitespace(){
            let color = UIColor(argbHexString: colorKey)
            button.setTitleColor(color, for: .normal)
        }
        
        if let fontSizeString = dictionary?[fontSizeKey.rawValue] as? String, let fontName = dictionary?[fontNameKey.rawValue] as? String
            , let fontSize = CGFloat(fontSizeString) ,let font = UIFont(name: fontName, size: CGFloat(fontSize)){
           button.titleLabel?.font = font
        }
    }
    
    //set text to label from plugin configuration
    public static func setButtonText(button: UIButton, textKey: ZappVerimatrixConfiguration.ConfigKey, from dictionary:[String:Any]?){
        if let labelText = dictionary?[textKey.rawValue] as? String, !labelText.isEmptyOrWhitespace(){
            button.setTitle(labelText, for: .normal)
        }
    }
    
    //set color to view from plugin configuration
    public static func setViewColor(view: UIView, colorKey: ZappVerimatrixConfiguration.ConfigKey, from dictionary:[String:Any]?){
        if let colorString = dictionary?[colorKey.rawValue] as? String , let color = UIColor(argbHexString: colorString){
            view.backgroundColor = color
        }
    }
    
    //set image to imageView from plugin configuration
    public static func setImageView(imageView: UIImageView, bundle: Bundle,key: ZappVerimatrixConfiguration.AssetKey){
        if let image = UIImage(named: key.rawValue, in: bundle, compatibleWith: nil){
            imageView.image = image
        }
    }
    
    //set image to button from plugin configuration
    public static func setButtonImage(button: UIButton, bundle: Bundle,key: ZappVerimatrixConfiguration.AssetKey){
        if let image = UIImage(named: key.rawValue, in: bundle, compatibleWith: nil){
           button.setImage(image, for: .normal)
        }
    }
    
    //set image BG to button from plugin configuration
    public static func setButtonBGImage(button: UIButton, bundle: Bundle,key: ZappVerimatrixConfiguration.AssetKey){
        if let image = UIImage(named: key.rawValue, in: bundle, compatibleWith: nil){
            button.setBackgroundImage(image, for: .normal)
        }
    }
    
}
