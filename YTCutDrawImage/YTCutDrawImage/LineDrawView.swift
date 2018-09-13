//
//  LineDrawView.swift
//  YTCutDrawImage
//
//  Created by yangtao on 2018/9/6.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

import UIKit

class LineDrawView: UIView {

    var array_Path = [CGPoint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, arrayPath: [CGPoint]) {
        self.init(frame: frame)
        
        array_Path = arrayPath
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else{return}
        if array_Path.count == 0 {return}
        
        //创建并设置路径
        let pathRef: CGMutablePath = CGMutablePath()
        pathRef.move(to: array_Path[0])
        pathRef.addLines(between: array_Path)
        
        //添加路径到图形上下文
        context.addPath(pathRef)
        
        //设置笔触的颜色和宽度
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(4)
        
        //绘制路径
        context.strokePath()
    }

}
