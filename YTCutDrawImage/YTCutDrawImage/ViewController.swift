//
//  ViewController.swift
//  YTCutDrawImage
//
//  Created by yangtao on 2018/9/6.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

import UIKit

private let kScreenW = UIScreen.main.bounds.size.width
private let kScreenH = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    fileprivate var view_Crop: CutDrawView!//图片画圈裁剪视图
    fileprivate var img_Draw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_Crop = CutDrawView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        view.addSubview(view_Crop)
        view_Crop.img_Show = UIImage(named: "carPic")
        view_Crop.getImage = {[weak self] image in
            guard let strongSelf = self else {return}
            
            strongSelf.img_Draw.image = image
        }
        
        img_Draw = UIImageView()
        img_Draw.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

