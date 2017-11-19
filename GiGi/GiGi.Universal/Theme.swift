//
//  Theme.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Timepiece

public struct Theme
{
	public enum Exception: Error
	{
		case invalidThemeData
	}
	
	public static var colors: Theme!

	var dayPallette: [UIColor]
	var nightPallette: [UIColor]

	public subscript(index: Int) -> UIColor
	{
		let pallette: [UIColor]
		switch Defaults.themeType.int
		{
		case 0: pallette = dayPallette; break
		case 1: pallette = nightPallette; break
		default: if Theme.isMorning { pallette = dayPallette } else { pallette = nightPallette }; break
		}
		return pallette[index]
	}

	public static var isMorning: Bool
	{
		let now = Date()
		let nowInt = now.hour * 100 + now.minute
		if nowInt > Defaults.dayTime.int && nowInt < Defaults.nightTime.int { return true } else { return false }
	}

	static func load() throws
	{
		let data = try Data(contentsOf: Bundle.main.url(forResource: "Harmony", withExtension: "json")!)
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
