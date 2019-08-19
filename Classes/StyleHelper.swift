//
//  StyleHelper.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 15/08/2019.
//

import Foundation

@objc class StyleHelper : NSObject{
    
    @objc public static func setLabel(label: UILabel, colorForKey: String, fontSizeKey: String, fontNameKey: String, textKey: String, from dictionary:[String:Any]?){
        if let colorKey = dictionary?[colorForKey] as? String, !colorKey.isEmptyOrWhitespace(){
            let color = UIColor(argbHexString: colorKey)
            label.textColor = color
        }
        
        if let fontSizeString = dictionary?[fontSizeKey] as? String, let fontName = dictionary?[fontNameKey] as? String
        , let fontSize = CGFloat(fontSizeString) ,let font = UIFont(name: fontName, size: CGFloat(fontSize)){
          label.font = font
        }
        
        if let labelText = dictionary?[textKey] as? String, !labelText.isEmptyOrWhitespace(){
           label.text = labelText
        }
    }
    
    @objc public static func setButton(button: UIButton, colorForKey: String, fontSizeKey: String, fontNameKey: String, textKey: String, from dictionary:[String:Any]?){
        if let colorKey = dictionary?[colorForKey] as? String, !colorKey.isEmptyOrWhitespace(){
            let color = UIColor(argbHexString: colorKey)
            button.setTitleColor(color, for: .normal)
        }
        
        if let fontSizeString = dictionary?[fontSizeKey] as? String, let fontName = dictionary?[fontNameKey] as? String
            , let fontSize = CGFloat(fontSizeString) ,let font = UIFont(name: fontName, size: CGFloat(fontSize)){
           button.titleLabel?.font = font
        }
        
        if let labelText = dictionary?[textKey] as? String, !labelText.isEmptyOrWhitespace(){
           button.setTitle(labelText, for: .normal)
        }
    }
    
    @objc public static func setViewColor(view: UIView, colorKey: String, from dictionary:[String:Any]?){
        if let colorString = dictionary?[colorKey] as? String , let color = UIColor(argbHexString: colorString){
            view.backgroundColor = color
        }
    }
    
}
