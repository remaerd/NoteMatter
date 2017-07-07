//
//  Button.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 07/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class DragableButton: UIView
{
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		backgroundColor = Theme.colors[6]
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func tintColorDidChange()
	{
		super.tintColorDidChange()
	}
}
