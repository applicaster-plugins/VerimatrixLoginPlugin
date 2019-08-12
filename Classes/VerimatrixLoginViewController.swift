//
//  VerimatrixLoginViewController.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 12/08/2019.
//

import UIKit
import ZappPlugins

class VerimatrixLoginViewController: UIViewController {
    
    public var delegate: VerimatrixBaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnDidPress(_ sender: UIButton) {
        if let delegate = delegate{
            delegate.closeBtnDidPress()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
