//
//  Font.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 18/11/2017.
//

import UIKit

public struct Font
{
	public enum FontWeight: String
	{
		case regular = ""
		case italic = "-Italic"
		case medium = "-Medium"
		case semibold = "-Semibold"
		case boldItalic = "BoldItalic"
		case bold = "-Bold"
		case heavy = "-Heavy"
	}
	
	public enum FontType: String
	{
		case regular
		case compact
		case code
	}
	
	public enum FontFamily: String
	{
		case sanFrancisco
		case plex
		
		func fontName(type: FontType, weight: FontWeight, size: CGFloat) -> UIFont!
		{
			if self == .plex
			{
				if type == .code { return UIFont(name: "iAWriterDuospace\(weight.rawValue)", size: size)! }
				else { return UIFont(name: "IBMPlexSans\(weight.rawValue)", size: size)! }
			}
			else
			{
				if type == .compact
				{
					if size > 15 { return UIFont(name: ".SFCompactDisplay\(weight.rawValue)", size: size)! }
					else { return UIFont(name: ".SFCompactText\(weight.rawValue)", size: size)! }
				}
				else
				{
					if size > 20 { return UIFont(name: ".SFUIDisplay\(weight.rawValue)", size: size)! }
					else { return UIFont(name: ".SFUIText\(weight.rawValue)", size: size)! }
				}
			}
		}
	}
}
