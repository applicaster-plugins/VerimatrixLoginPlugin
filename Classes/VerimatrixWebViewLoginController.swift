//
//  VerimatrixWebViewLoginController.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 18/08/2019.
//

import UIKit

class VerimatrixWebViewLoginController: UIViewController {
    
    var webViewController: UIViewController?
    var delegate: VerimatrixBaseProtocol?
    var configurationJson : [String:Any]?
    
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var navBackground: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: type(of: self))
        StyleHelper.setImageView(imageView: logoImageView, bundle: bundle, key: .logoImage)
        StyleHelper.setButtonImage(button: closeBtn, bundle: bundle, key: .closeBtn)
        StyleHelper.setViewColor(view: navBackground, colorKey: .background, from: configurationJson)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func closeBtnDidPress(_ sender: UIButton) {
        if let delegate = delegate{
            delegate.webviewCloseBtnDidPress()
        }
    }

    //prevent landscape orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
}
