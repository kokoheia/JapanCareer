//
//  GradientMaker.swift
//  JapanCareer
//
//  Created by Kohei Arai on 2018/03/29.
//  Copyright © 2018年 Kohei Arai. All rights reserved.
//

import UIKit


class GradientMaker {
    static func makeGradient(color1: CGColor, color2: CGColor, point1: CGPoint, point2: CGPoint, view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = point1
        gradientLayer.endPoint = point2
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.clipsToBounds = true
    }
}
