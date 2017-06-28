//
//  UINavigationController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

class UINavigationController: UIKit.UINavigationController
{
	override init(rootViewController: UIViewController)
	{
		super.init(rootViewController: rootViewController)
		isNavigationBarHidden = true
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
	{
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
