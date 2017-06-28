//
//  Theme.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

public struct Theme
{
	public enum Exception: Error
	{
		case invalidThemeData
	}

	public static var shared: Theme!

	public var dayPallette: [UIColor]
	public var nightPallette: [UIColor]

	static func load() throws
	{
		let themeURL: URL
		if let url = UserDefaults.standard.url(forKey: "defaults.theme") { themeURL = url } else
		{
			let defaultThemeURL = URL.bundle.url(forResource: "Harmony", withExtension: "json")!
			UserDefaults.standard.set(defaultThemeURL, forKey: "defaults.theme")
			themeURL = defaultThemeURL
		}

		let data = try Data(contentsOf: themeURL)
		if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
		{
			if let day = json["day"] as? [String], let night = json["night"] as? [String]
			{
				var dayColor = [UIColor]()
				var nightColor = [UIColor]()
				for color in day { dayColor.append(UIColor(hex: color)) }
				for color in night { nightColor.append(UIColor(hex: color)) }
				Theme.shared = Theme(dayPallette: dayColor, nightPallette: nightColor)
				return
			}
		}
		throw Exception.invalidThemeData
	}
}
