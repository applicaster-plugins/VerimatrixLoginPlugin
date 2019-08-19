//
//  VerimatrixWebViewLoginController.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 18/08/2019.
//

import UIKit

class VerimatrixWebViewLoginController: UIViewController {
    var webViewController: UIViewController?
    @IBOutlet weak var webViewContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
