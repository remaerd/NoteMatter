//
//  UIViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

internal enum TransitionType
{
	case `default`
	case left
	case right
	case bottom
	case syste
}

protocol EnhancedViewController
{
	var backgroundTintColor : UIColor { get }
	var pushTransition: TransitionType { get }
	var popTransition : TransitionType { get }
	var headerHeight : CGFloat { get }
	var searchPlaceHolder : String? { get }
}

class UIViewController: UIKit.UIViewController, EnhancedViewController
{
	var backgroundTintColor : UIColor { return Theme.colors[1] }
	var pushTransition : TransitionType { return TransitionType.default }
	var popTransition : TransitionType { return TransitionType.default }
	var headerHeight : CGFloat {return Constants.topBarHeight + Constants.statusBarHeight }
	var searchPlaceHolder : String? { return nil }

	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		if backgroundTintColor.isVisibleOnWhiteBackground == false { return UIStatusBarStyle.default }
		return UIStatusBarStyle.lightContent
	}
}
