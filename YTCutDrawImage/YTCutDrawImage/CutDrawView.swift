//
//  CutDrawView.swift
//  YTCutDrawImage
//
//  Created by yangtao on 2018/9/6.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

import UIKit

typealias GetCutImgae = (UIImage) -> Void

class CutDrawView: UIView {

    fileprivate var img_Car: UIImageView! //车img
    fileprivate var view_GetImgBg: UIView! //图片bg,用于截取当前大小的image
    fileprivate var img_GetBg: UIImage! //获取当前的图片, 用于截图, 这样避免图片像素影响, 使用当前显示的大小
    fileprivate var view_Crop: LineDrawView! //专门用于画线 因为img不能画线
    fileprivate var img_Crop: UIImageView! //根据花圈区域截的图
    fileprivate var array_TouchCrop = [CGPoint]() //画圈点 相对于背景view的位置
    fileprivate var array_TouchImage = [CGPoint]() //相对于车图的位置

    var getImage: GetCutImgae? //将截图通过闭包传出去
    
    var img_Show: UIImage?{
        didSet{
            guard let img = img_Show else {return}
            img_Car.image = img
            img_GetBg = getCurrentFrameImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CutDrawView{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initCropImageStatus()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        array_TouchImage.append(touches.first!.location(in: img_Car))
        array_TouchCrop.append(touches.first!.location(in: view_Crop))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if array_TouchCrop.count == 0{return}
        
        createPath()
        
        var topPoint: CGPoint = array_TouchImage[0]
        var righttPoint: CGPoint = array_TouchImage[0]
        var bottomPoint: CGPoint = array_TouchImage[0]
        var leftPoint: CGPoint = array_TouchImage[0]
        
        for item in array_TouchImage{
            if item.y < topPoint.y{
                topPoint = item
            }
            if item.x > righttPoint.x{
                righttPoint = item
            }
            if item.y > bottomPoint.y{
                bottomPoint = item
            }
            if item.x < leftPoint.x{
                leftPoint = item
            }
        }
        
        //设置最小的画圈范围, 小于10则不进行处理
        if bottomPoint.y - topPoint.y <= 10{
            return
        }
        if righttPoint.x - leftPoint.x <= 10{
            return
        }
        
        let frame = CGRect(x: leftPoint.x, y: topPoint.y, width: righttPoint.x - leftPoint.x, height: bottomPoint.y - topPoint.y)
        
        img_Crop.frame = frame
        img_Crop.image = clipWithImageRect(clipFrame: frame, bgImage: img_GetBg)
        img_Car.isHidden = true
        img_Crop.isHidden = false
        
        if let block = getImage{
            block(img_Crop.image ?? UIImage.init())
        }
    }
    
    //获取当前显示图片大小的图
    func getCurrentFrameImage() -> UIImage {
        
        UIGraphicsBeginImageContext(view_GetImgBg.bounds.size)
        
        view_GetImgBg.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imgae = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imgae!
    }
    
    func initCropImageStatus() {
        array_TouchCrop.removeAll()
        array_TouchImage.removeAll()
        createPath()
        img_Car.isHidden = false
        img_Crop.isHidden = true
    }
    
    func createPath() {
        
        view_Crop.array_Path = array_TouchCrop
        view_Crop.setNeedsDisplay() //重绘
    }
    
    func clipWithImageRect(clipFrame: CGRect, bgImage: UIImage) -> UIImage {
        
        let rect_Scale = CGRect(x: clipFrame.origin.x, y: clipFrame.origin.y, width: clipFrame.size.width, height: clipFrame.size.height)
        
        let cgImageCorpped = bgImage.cgImage?.cropping(to: rect_Scale)
        let img_Clip = UIImage.init(cgImage: cgImageCorpped!, scale: 1, orientation: UIImageOrientation.up)
        
        return img_Clip
    }
    
}

private let kScreenW = UIScreen.main.bounds.size.width
private let kScreenH = UIScreen.main.bounds.size.height
private let margin_TopMid: CGFloat = 25

extension CutDrawView{
    
    func createView() {
        
        let width_Img = kScreenW / 375 * 175
        let margin_LeftImg = (kScreenW - width_Img) / 2
        
        view_GetImgBg = UIView()
        addSubview(view_GetImgBg)
        view_GetImgBg.frame = CGRect(x: margin_LeftImg, y:  margin_TopMid, width: width_Img, height: kScreenH - margin_TopMid * 2)
        
        img_Car = UIImageView()
        img_Car.contentMode = .scaleToFill
        img_Car.isUserInteractionEnabled = true
        img_Car.frame = CGRect(x: 0, y: 0, width: view_GetImgBg.frame.size.width, height: view_GetImgBg.frame.size.height)
        view_GetImgBg.addSubview(img_Car)
        
        view_Crop = LineDrawView(frame: .zero, arrayPath: array_TouchCrop)
        addSubview(view_Crop)
        view_Crop.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        
        img_Crop = UIImageView()
        img_Crop.isHidden = true
        view_GetImgBg.addSubview(img_Crop)
    }
    
}
