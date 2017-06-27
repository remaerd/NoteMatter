//
//  Color.swift
//  GiGi
//
//  Created by Sean Cheng on 27/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

public enum UIColorException: Error
{
	case invalidHex
}

public extension UIColor
{
	convenience init?(red: Float, green: Float, blue: Float)
	{
		#if os(iOS)
			self.init(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: 1.0)
			if (!(red >= 0 && red <= 255) || !(green >= 0 && green <= 255) || !(blue >= 0 && blue <= 255)) { return nil }
		#else
			self.init(calibratedRed: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: 1.0)
			if (!(red >= 0 && red <= 255) || !(green >= 0 && green <= 255) || !(blue >= 0 && blue <= 255)) { return nil }
		#endif
	}

	convenience init(hex: String)
	{
		var hexValue : CUnsignedLongLong = 0
		var red:   CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue:  CGFloat = 0.0
		var alpha: CGFloat = 1.0

		if Scanner(string: hex).scanHexInt64(&hexValue)
		{
			switch (hex.lengthOfBytes(using: String.Encoding.utf8))
			{
			case 3:
				red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
				green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
				blue  = CGFloat(hexValue & 0x00F)              / 15.0
			case 4:
				red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
				green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
				blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
				alpha = CGFloat(hexValue & 0x000F)             / 15.0
			case 6:
				red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
				green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
				blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
			case 8:
				red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
				green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
				blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
				alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
			default: break
			}
		}

		#if os(iOS)
			self.init(red: red, green: green, blue: blue, alpha: alpha)
		#else
			self.init(calibratedRed: red, green: green, blue: blue, alpha: alpha)
		#endif
	}

	var hexValue : String
	{
		let rgb = self.cgColor.components
		let r = Int((rgb?[0])! * 255.0)
		let g = Int((rgb?[1])! * 255.0)
		let b = Int((rgb?[2])! * 255.0)
		return NSString(format: "%02x%02x%02x", r,g,b) as String
	}

	func isVisibleOnWhiteBackground() -> Bool
	{
		var red   : CGFloat = 0
		var green : CGFloat = 0
		var blue  : CGFloat = 0
		var alpha : CGFloat = 0
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		red *= 0.2126
		green *= 0.7152
		blue *= 0.0722
		let luminance = red + green + blue
		if luminance > 0.7 { return false } else { return true }
	}
}
