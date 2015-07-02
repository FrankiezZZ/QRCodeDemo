//
//  ViewController.swift
//  QRCodeDemo
//
//  Created by 汤蓉 on 15/7/2.
//  Copyright © 2015年 zhm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 扫描线高度偏移布局
    var scanHeightCon: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 背景颜色
        view.backgroundColor = UIColor.whiteColor()
        setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scanAnimation()
    }
    
    func setupView() {
        view.addSubview(cameraView)
        cameraView.addSubview(scanLineView)
        
        // 添加约束
        // 照相框图片
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: cameraView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: cameraView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[subView(250)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView": cameraView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[subView(250)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView": cameraView]))
        
        // 扫描线图片
        scanLineView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.addConstraint(NSLayoutConstraint(item: scanLineView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: cameraView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        scanHeightCon = NSLayoutConstraint(item: scanLineView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: cameraView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -250)
        cameraView.addConstraint(scanHeightCon!)
        cameraView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[subView(250)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView": scanLineView]))
        cameraView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[subView(250)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView": scanLineView]))
    }
    
    // 扫描动画
    func scanAnimation() {
        scanHeightCon!.constant = 250
        UIView.animateWithDuration(1.5) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - 懒加载控件
    // 照相框图片
    lazy var cameraView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "qrcode_border"))
        imgView.clipsToBounds = true
        return imgView
    }()
    // 扫描线图片
    lazy var scanLineView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "qrcode_scanline_qrcode"))
        return imgView
    }()
    
}

