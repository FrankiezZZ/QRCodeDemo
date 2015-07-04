//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by 汤蓉 on 15/7/2.
//  Copyright © 2015年 zhm. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
//    // 扫描线高度偏移布局
//    var scanHeightCon: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayers()
        setupSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.scanAnimation()
        startScan()
    }
    
    func setupView() {
        view.addSubview(backgroundView)
    }

    // MARK: - 懒加载控件
    // 背景容器View
    lazy var backgroundView: QRCodeView = {
        let view = QRCodeView(frame: self.view.bounds)
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    // MARK - 二维码扫描
    // 开始扫描
    func startScan() {
        session.startRunning()
    }
    
    // 设置图层
    private func setupLayers() {
        // 设置图层样式
        drawLayer.frame = view.bounds
        backgroundView.layer.insertSublayer(drawLayer, atIndex: 0)
        
        // 设置预览图层
        previewLayer.frame = view.bounds
        // 设置图层填充模式
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        // 将图层添加到当前图层
        backgroundView.layer.insertSublayer(previewLayer, atIndex: 0)
    }
    
    private func setupSession() {
        // 判断是否加入设备
        if !session.canAddInput(inputDevice) {
            return
        }
        
        // 判断能否添加输出数据
        if !session.canAddOutput(outputData) {
            return
        }
        
        // 添加设备
        session.addInput(inputDevice)
        session.addOutput(outputData)
        
        // 设置检测数据类型，检测所有支持的数据格式
        outputData.metadataObjectTypes = outputData.availableMetadataObjectTypes
        
        // 设置数据的代理
        outputData.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for object in metadataObjects {
            // 判断识别对象类型
            if object is AVMetadataMachineReadableCodeObject {
                // 转换数据类型
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                print(codeObject.stringValue)
                backgroundView.addSubview(resultLabel!)
                resultLabel!.frame.origin.y = 40
                resultLabel!.text = codeObject.stringValue
                resultLabel!.sizeToFit()
            }
        }
    }
    
    // MARK - 懒加载
    // 绘图图层
    lazy var drawLayer: CALayer = CALayer()
    
    // 预览视图，依赖于session的
    lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    // session桥梁
    lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 输入设备
    lazy var inputDevice: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            return try AVCaptureDeviceInput(device: device)
        } catch {
            print(error)
            return nil
        }
        }()
    
    // 输出结果的Label
    lazy var resultLabel: UILabel? = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    // 输出数据
    lazy var outputData: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
}

