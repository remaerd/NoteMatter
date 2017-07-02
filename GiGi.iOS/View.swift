//
//  View.swift
//  GiGi
//
//  Created by Sean Cheng on 30/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

extension UIView
{
	func drawSeperator(y: CGFloat, left: CGFloat, right: CGFloat, color: UIColor = Theme.colors[1]) -> CALayer
	{
		let seperator = CALayer()
		seperator.backgroundColor = color.cgColor
		let width = UIScreen.main.bounds.width - right + left
		seperator.frame = CGRect(x: left, y: self.bounds.height - 1, width: width, height: 0.5)
		return seperator
	}
}
