//
//  VerimatrixLoginViewController.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 12/08/2019.
//

import Foundation
import ZappPlugins

class VerimatrixLoginViewController: UIViewController ,UIPickerViewDelegate , UIPickerViewDataSource {
    
    
    public var providersName:[String]?
    public var delegate: VerimatrixBaseProtocol?
    public var configurationJson : NSDictionary?
    
    @objc @IBOutlet fileprivate weak var closeButton: UIButton!
    @objc @IBOutlet fileprivate weak var logoImageView: UIImageView!
    @objc @IBOutlet fileprivate weak var chooseProviderLabel: UILabel!
    @objc @IBOutlet fileprivate weak var providerPickerView: UIPickerView!
    @objc @IBOutlet fileprivate weak var loginButton: UIButton!
    @objc @IBOutlet fileprivate weak var backgroundView: UIView!
    @objc @IBOutlet fileprivate weak var webViewContainer: UIView!
    
    
    
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
        if let delegate = delegate, let resource = providersName?[providerPickerView.selectedRow(inComponent: 0)]{
        delegate.providerSelected(provider: resource)
       }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func login(url: String){
        let webview = VerimatrixWebViewController(url: URL(string: url))
        //webview?.redirectUriDelegate = self
        self.addChildViewController(webview, to: self.webViewContainer)
        self.webViewContainer.isHidden = false
        webview?.loadTargetURL()
    }
    
    func setupView(){
        guard let styleManager = ZAAppConnector.sharedInstance().layoutsStylesDelegate else {
            return
        }
        self.providerPickerView.delegate = self
        self.providerPickerView.dataSource = self
        StyleHelper.setLabel(label: chooseProviderLabel, colorForKey: "", fontSizeKey: "", fontNameKey: "", textKey: ZappVerimatrixConfiguration.ConfigKey.providersScreenTitle.rawValue, from: configurationJson as? [String : Any] )
        StyleHelper.setButton(button: loginButton, colorForKey: "", fontSizeKey: "", fontNameKey: "", textKey: ZappVerimatrixConfiguration.ConfigKey.providersScreenActionBtnTitle.rawValue, from: configurationJson as? [String : Any] )
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return providersName?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return providersName?[row]
    }
    
    
}
