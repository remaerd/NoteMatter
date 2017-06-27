//
//  ThemeReducer.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift
import Foundation

public func themeReducer(action: Action, state: ThemeState?) -> ThemeState
{
	var themeState = state ?? ThemeState()

	func loadTheme()
	{
		let themeURL: URL
		if let url = UserDefaults.standard.url(forKey: "defaults.theme") { themeURL = url } else
		{
			let defaultThemeURL = URL.bundle.url(forResource: "Harmony", withExtension: "json")!
			UserDefaults.standard.set(defaultThemeURL, forKey: "defaults.theme")
			themeURL = defaultThemeURL
		}

		do
		{
			let data = try Data(contentsOf: themeURL)
			print(data)
			if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
			{
				if let day = json["day"] as? [String], let night = json["night"] as? [String]
				{
					var dayColor = [UIColor]()
					var nightColor = [UIColor]()
					for color in day { dayColor.append(UIColor(hex: color)) }
					for color in night { nightColor.append(UIColor(hex: color)) }
					themeState.dayPallette = dayColor
					themeState.nightPallette = nightColor
				} else { themeState.status = .invalidThemeData }
			}

			themeState.status = .loaded
		} catch { themeState.status = .invalidThemeData }
	}

	func switchTheme(fileURL: URL)
	{

	}

	switch action {
	case _ as ThemeActions.Load: loadTheme()
	case let action as ThemeActions.Switch: switchTheme(fileURL: action.fileURL)
	default: break

	}

	return themeState
}
