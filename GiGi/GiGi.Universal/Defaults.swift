//
//  Defaults.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

public enum Defaults : String
{
	case themeType = "theme-type"
	case dayTime = "day-time"
	case nightTime = "night-time"
	case listHeight = "list-height"
	case soundEffect = "sound-effect"
	case hideCompletedTasks = "hide-completed-tasks"
	case assistant = "assistant"
	case assistantLevel = "assistant-level"
	case assistantBriefing = "assistant-briefing"
	case assistantLazy = "assistant-lazy"
	case assistantBusy = "assistant-busy"
	case assistantDelay = "assistant-delay"
	
	var defaultValue: Any
	{
		switch self
		{
		case .themeType: return 0
		case .dayTime: return 600
		case .nightTime: return 2000
		case .listHeight: return Float(250.0)
		case .soundEffect: return true
		case .hideCompletedTasks: return true
		case .assistant: return true
		case .assistantLevel: return 0
		case .assistantBriefing: return 800
		case .assistantLazy: return 1
		case .assistantBusy: return 1
		case .assistantDelay: return 1
		}
	}
}

public var strictAssistantPolicy = [ Defaults.assistantLazy: 7, Defaults.assistantBusy: 10, Defaults.assistantDelay: 3 ]
public var looseAssistantPolicy = [ Defaults.assistantLazy: 3, Defaults.assistantBusy: 5, Defaults.assistantDelay: 1 ]

public extension Defaults
{
	var string: String { return get() as! String }
	var float: CGFloat { return CGFloat(get() as! Float) }
	var int: Int { return Int(get() as! Int)  }
	var bool: Bool { return get() as! Bool }
	var date: Date { return get() as! Date }
	
	func get() -> Any
	{
		var result : Any?
		if let url = AppDefaults.cache[self.rawValue] { result = url } else { result = UserDefaults.standard.value(forKey: self.rawValue) }
		if result == nil
		{
			result = self.defaultValue
			UserDefaults.standard.set(result!, forKey: self.rawValue)
		}
		return result!
	}
	
	func set(value: Any)
	{
		AppDefaults.cache[self.rawValue] = value
		UserDefaults.standard.set(value, forKey: self.rawValue)
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
