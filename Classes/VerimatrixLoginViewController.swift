//
//  VerimatrixLoginViewController.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 12/08/2019.
//

import Foundation
import ZappPlugins

class VerimatrixLoginViewController: UIViewController ,UIPickerViewDelegate , UIPickerViewDataSource {
    
    var providersName:[String]?
    var providersIdp:[String]?
    var delegate: VerimatrixBaseProtocol?
    var configurationJson : [String:Any]?
    var test = ["cat","dog","mouse","lion","tiger"]
   
    @objc @IBOutlet fileprivate weak var closeButton: UIButton!
    @objc @IBOutlet fileprivate weak var logoImageView: UIImageView!
    @objc @IBOutlet fileprivate weak var chooseProviderLabel: UILabel!
    @objc @IBOutlet fileprivate weak var providerPickerView: UIPickerView!
    @objc @IBOutlet fileprivate weak var loginButton: UIButton!
    @objc @IBOutlet fileprivate weak var backgroundView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
   @objc @IBAction fileprivate func closeBtnDidPress(_ sender: UIButton) {
        if let delegate = delegate{
            delegate.closeBtnDidPress()
        }
    }
    
   @objc @IBAction fileprivate func loginBtnDidPress(_ sender: UIButton) {
        if let delegate = delegate, let resource = providersIdp?[providerPickerView.selectedRow(inComponent: 0)]{
        delegate.providerSelected(provider: resource)
       }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //setting all views with helper from the plugin configuration ans assets
    func setupView(){
        self.providerPickerView.delegate = self
        self.providerPickerView.dataSource = self
        let bundle = Bundle(for: type(of: self))
        StyleHelper.setViewColor(view: backgroundView, colorKey: .background, from: configurationJson)
        StyleHelper.setLabelStyle(label: chooseProviderLabel, colorForKey: .titleColor, fontSizeKey: .titleSize , fontNameKey: .titleFont, from: configurationJson)
        StyleHelper.setLabelText(label: chooseProviderLabel, textKey: .providersScreenTitle, from: configurationJson)
        StyleHelper.setButtonText(button: loginButton, textKey: .actionBtnTitle, from: configurationJson)
        StyleHelper.setButtonStyle(button: loginButton, colorForKey: .actionBtnTitleColor, fontSizeKey: .actionBtnTitleSize, fontNameKey: .actionBtnTitleFont, from: configurationJson)
        StyleHelper.setImageView(imageView: logoImageView, bundle: bundle, key: .logoImage)
        StyleHelper.setButtonImage(button: closeButton, bundle: bundle, key: .closeBtn)
        StyleHelper.setButtonBGImage(button: loginButton, bundle: bundle, key: .loginBtn)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return test.count
    }
    
    //setting different color for the selected value and the else
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for view in pickerView.subviews {
        
            if view.frame.size.height < 1 {
                var frame = view.frame
                frame.size.height = 1
                view.frame = frame
                view.backgroundColor = UIColor(red: 52/255.0, green: 54/255, blue: 54/255, alpha: 1)
            }
        }
        
        let label = UILabel()
        label.text = test[row]
        label.textAlignment = NSTextAlignment.center
        if(row == pickerView.selectedRow(inComponent: component)){
            StyleHelper.setLabelStyle(label: label, colorForKey: .pickerSelectedColor, fontSizeKey: .pickerSelectedSize , fontNameKey: .pickerSelectedFont, from: configurationJson)
        }else{
            StyleHelper.setLabelStyle(label: label, colorForKey: .pickerDeafultColor, fontSizeKey: .pickerSelectedSize , fontNameKey: .pickerDeafultFont, from: configurationJson)
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
}
