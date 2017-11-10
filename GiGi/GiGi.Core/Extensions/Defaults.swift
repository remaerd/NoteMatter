//
//  Defaults.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

public enum Defaults : String
{
	case theme = "com.zhengxingzhi.xingzhi.theme"
	case themeType = "com.zhengxingzhi.xingzhi.theme-type"
	case dayTime = "com.zhengxingzhi.xingzhi.day-time"
	case nightTime = "com.zhengxingzhi.xingzhi.night-time"
	case listHeight = "com.zhengxingzhi.xingzhi.list-height"

	var defaultValue: Any
	{
		switch self
		{
		case .theme: return URL.bundle.url(forResource: "Harmony", withExtension: "json")!
		case .themeType: return 0
		case .dayTime: return 800
		case .nightTime: return 2000
		case .listHeight: return Float(250.0)
		}
	}
}

public extension Defaults
{
	var string: String
	{
		var result : String?
		if let float = AppDefaults.cache[self.rawValue] as? String { result = float } else { result = UserDefaults.standard.value(forKey: self.rawValue) as? String }
		if result == nil
		{
			result = self.defaultValue as? String
			UserDefaults.standard.set(result!, forKey: self.rawValue)
		}
		return String(result!)
	}

	var float: CGFloat
	{
		var result : Float?
		if let float = AppDefaults.cache[self.rawValue] as? Float { result = float } else { result = UserDefaults.standard.value(forKey: self.rawValue) as? Float }
		if result == nil
		{
			result = self.defaultValue as? Float
			UserDefaults.standard.set(result!, forKey: self.rawValue)
		}
		return CGFloat(result!)
	}

	var bool: Bool
	{
		var result : Bool?
		if let float = AppDefaults.cache[self.rawValue] as? Bool { result = float } else { result = UserDefaults.standard.value(forKey: self.rawValue) as? Bool }
		if result == nil
		{
			result = self.defaultValue as? Bool
			UserDefaults.standard.set(result!, forKey: self.rawValue)
		}
		return result!
	}

	var int: Int
	{
		var result : Int?
		if let float = AppDefaults.cache[self.rawValue] as? Int { result = float } else { result = UserDefaults.standard.value(forKey: self.rawValue) as? Int }
		if result == nil
		{
			result = self.defaultValue as? Int
			UserDefaults.standard.set(result!, forKey: self.rawValue)
		}
		return result!
	}

	var url: URL
	{
		var result : URL?
		if let url = AppDefaults.cache[self.rawValue] as? URL { result = url } else { result = UserDefaults.standard.value(forKey: self.rawValue) as? URL }
		if result == nil
		{
			result = self.defaultValue as? URL
			UserDefaults.standard.set(result!, forKey: self.rawValue)
		}
		return result!
	}
}

public class AppDefaults: UserDefaults
{
	static var cache = [String:Any]()

	public override func setValue(_ value: Any?, forKey key: String)
	{
		AppDefaults.cache[key] = value
	}
}
