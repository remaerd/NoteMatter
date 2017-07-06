//
//  Theme.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation
import Timepiece

public struct Theme
{
	public enum Exception: Error
	{
		case invalidThemeData
	}

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

	public static var colors: Theme!

	var dayPallette: [UIColor]
	var nightPallette: [UIColor]

	public static var CellFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		print(FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size))
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()

	public static var SolutionFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()

	public static var SearchBarTextFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .medium, fontSize: size), size: size)!
	}()

	public static var SearchBarButtonFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .medium, fontSize: size), size: size)!
	}()

	public static var TaskCellFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return UIFont(name: FontFamily.sanFranciscoCompact.fontName(fontWeight: .semibold, fontSize: size), size: size)!
	}()

	public static var TaskHeaderFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).pointSize
		return UIFont(name: FontFamily.sanFranciscoCompact.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()

	public static var TaskDescriptionFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: FontFamily.sanFranciscoCompact.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()

	public static var EditorRegularFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()

	public static var EditorItalicFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .italic, fontSize: size), size: size)!
	}()

	public static var EditorBoldFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()

	public static var EditorHeader1Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .heavy, fontSize: size), size: size)!
	}()

	public static var EditorHeader2Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()

	public static var EditorHeader3Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()

	public static var EditorHeader4Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()

	public subscript(index: Int) -> UIColor
	{
		let pallette: [UIColor]
		switch Defaults.themeType.int
		{
		case 1: pallette = dayPallette; break
		case 2: pallette = nightPallette; break
		default:
			let now = Date()
			let nowInt = now.hour * 100 + now.minute
			if nowInt > Defaults.dayTime.int && nowInt < Defaults.nightTime.int { pallette = dayPallette } else { pallette = nightPallette }
			break
		}
		return pallette[index]
	}

	static func load() throws
	{
		let data = try Data(contentsOf: Defaults.theme.url)
		if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
		{
			if let day = json["day"] as? [String], let night = json["night"] as? [String]
			{
				var dayColor = [UIColor]()
				var nightColor = [UIColor]()
				for color in day { dayColor.append(UIColor(hex: color)) }
				for color in night { nightColor.append(UIColor(hex: color)) }
				Theme.colors = Theme(dayPallette: dayColor, nightPallette: nightColor)
				return
			}
		}
		throw Exception.invalidThemeData
	}

	// TODO: 完善自动切换主题功能
}
