//
//  QRCode.swift
//  QRCode
//
//  Created by dayu on 15/6/30.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

import UIKit
import AVFoundation

public class QRCode: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var lineWidth: CGFloat
    var strokeColor: UIColor
    var scanFrame: CGRect = CGRectZero
    var completedCallBack: ((string: String)->())?
    
    
    public override init() {
        lineWidth = 4.0;
        strokeColor = UIColor.greenColor();
        super.init()
    }
    
    public init(lineWidth: CGFloat, strokeColor: UIColor) {
        self.lineWidth = lineWidth;
        self.strokeColor = strokeColor;
        super.init()
    }
    
    deinit {
        if session.running {
            session.stopRunning()
        }
        
    }
    
    lazy var qrCodeFrameView: UIView = {
       return UIView()
    }()
    
    lazy var qrCodeView: UIView = {
        return UIView()
    }()
    
    lazy var session: AVCaptureSession = {
        return AVCaptureSession()
    }()
    
    lazy var videoInput: AVCaptureDeviceInput? = {
        if let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            return AVCaptureDeviceInput(device: device, error: nil)
        }
        return nil
    }()
    
    
    lazy var dataOutput: AVCaptureMetadataOutput = {
        return AVCaptureMetadataOutput()
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return layer
    }()
    
    lazy var drawLayer: CALayer = {
       return CALayer()
    }()
    
    public func prepareScan(view: UIView, completed:((string: String)->())?) {
        if let callBack = completed {
            completedCallBack = callBack
        }
        setupSession()
        setupLayer(view)
    }
    
    private func setupLayer(view: UIView) {
        drawLayer.frame = view.bounds
        view.layer.insertSublayer(drawLayer, atIndex: 0)
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, atIndex: 0)
    }
    
    private func setupSession() {
        if session.running {
            print("the capture session is running!");
            return
        }
        if !session.canAddInput(videoInput) {
            print("can not add input device!");
            return
        }
        if !session.canAddOutput(dataOutput) {
            print("can not add output device!");
        }
        
        session.addInput(videoInput);
        session.addOutput(dataOutput);
        
        dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes;
        dataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue());
    }
    
    public func startScan() {
        if session.running {
            return
        }
        
        session.startRunning()
    }
    
    public func stopScan() {
        if session.running {
            session.stopRunning();
        }
        return
    }
    
    
    public func generateQRCode(stringValue: String, icon: UIImage?, iconScale: CGFloat = 0.25, color: CIColor, backColor: CIColor) -> UIImage? {
    
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter.setDefaults()
        qrFilter.setValue(stringValue.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), forKey: "inputMessage")
        let ciImage = qrFilter.outputImage
        
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter.setDefaults()
        colorFilter.setValue(ciImage, forKey: "inputImage")
        colorFilter.setValue(color, forKey: "inputColor0")
        colorFilter.setValue(backColor, forKey: "inputColor1")
        
        let transform = CGAffineTransformMakeScale(5, 5)
        let transformedImage = colorFilter.outputImage.imageByApplyingTransform(transform)
        
        let image = UIImage(CIImage: transformedImage)
        
        if icon != nil && image != nil {
            return insertIcon(image!, icon:icon!, scale:iconScale)
        }
        
        return image
    }
    
    private func insertIcon(codeImage: UIImage, icon: UIImage, scale: CGFloat) -> UIImage{
        let rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        
        codeImage.drawInRect(rect)
        
        let iconSize = CGSizeMake(rect.size.width * scale, rect.size.height * scale)
        let x = (rect.width - iconSize.width) * 0.5
        let y = (rect.height - iconSize.height) * 0.5
        icon.drawInRect(CGRectMake(x, y, iconSize.width, iconSize.height))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    lazy var shapeLayer: CAShapeLayer = {
       return CAShapeLayer()
    }()
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRectZero
            return
        }
        
        for dataOutput in metadataObjects {
            
            if let codeObject = dataOutput as? AVMetadataMachineReadableCodeObject {
                let barCodeObject = previewLayer.transformedMetadataObjectForMetadataObject(codeObject) as! AVMetadataMachineReadableCodeObject
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.borderWidth = lineWidth
                shapeLayer.borderColor = strokeColor.CGColor
                shapeLayer.frame = barCodeObject.bounds
                
                if drawLayer.sublayers != nil && drawLayer.sublayers.count > 0 {
                    for layer in drawLayer.sublayers {
                        layer.removeFromSuperlayer()
                    }
                }
                
                drawLayer.addSublayer(shapeLayer)
                
                completedCallBack?(string: codeObject.stringValue)
            }
        }
    }
}