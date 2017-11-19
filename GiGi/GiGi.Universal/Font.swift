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
		case bold = "-Bold"
		case heavy = "-Heavy"
	}
	
	public enum FontFamily: String
	{
		case sanFranciscoUI
		case sanFranciscoCompact
		
		func fontName(fontWeight: FontWeight, fontSize: CGFloat) -> String
		{
			switch self
			{
			case .sanFranciscoUI: if fontSize > 20 { return ".SFUIDisplay\(fontWeight.rawValue)" } else { return ".SFUIText\(fontWeight.rawValue)"}
			case .sanFranciscoCompact: if fontSize > 15 { return ".SFCompactDisplay\(fontWeight.rawValue)"} else { return ".SFCompactText\(fontWeight.rawValue)"}
			}
		}
	}
}
