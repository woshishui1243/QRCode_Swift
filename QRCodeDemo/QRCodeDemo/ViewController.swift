//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by dayu on 15/6/30.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

import UIKit
import AVFoundation
import QRCode

class ViewController: UIViewController {
    
    let qrCodeScaner = QRCode(lineWidth: 3.0, strokeColor: UIColor.greenColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrCodeScaner.prepareScan(view) {
            (string) in
                if let url = NSURL(string: string) {
                    UIApplication.sharedApplication().openURL(url)
                }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        qrCodeScaner.startScan()
    }

}

