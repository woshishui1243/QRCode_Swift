//
//  QRCodeViewController.swift
//  QRCodeDemo
//
//  Created by dayu on 15/7/1.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

import UIKit
import QRCode

class QRCodeViewController: UIViewController {

    @IBOutlet weak var qrCodeView: UIImageView!
    
    let qrCode = QRCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let icon = UIImage(named: "avatar")
        let color = CIColor(color: UIColor.blackColor())
        let backColor = CIColor(color: UIColor.whiteColor())
        qrCodeView.image = qrCode.generateQRCode("http://www.baidu.com", icon: icon, iconScale: 0.2, color: color!, backColor: backColor!)
    }
    

}
