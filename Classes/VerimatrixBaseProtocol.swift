//
//  VerimatrixBaseProtocol.swift
//  VerimatrixLoginPlugin
//
//  Created by MSApps on 12/08/2019.
//

import Foundation
import AVFoundation

@objc public protocol VerimatrixBaseProtocol {
    func closeBtnDidPress()
    func webviewCloseBtnDidPress()
    func providerSelected(provider: String)
    func errorOnApi()
}
