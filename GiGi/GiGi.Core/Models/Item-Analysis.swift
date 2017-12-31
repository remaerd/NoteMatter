//
//  Item-Analysis.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 30/12/2017.
//

import Foundation

public extension Item
{
	public enum AssistantActionType: String
	{
		case firstLaunch = ".assistant.firstLaunch" // 首次打开软件
		case lazyBone = ".assistant.lazy" // 长期不打开软件
		case tooManyUnscheduleTask = ".assistant.tooManyUnscheduleTasks" // 太多无限期的任务
		case idle = ".assistant.idle"  // 空闲，提一些不着边际的建议，启发一下用户
		case emptyProject = ".assistant.emptyProject"  //空项目，提醒用户开始
		case delay = ".assistant.delay"  // 少量没有完成任务
		case seriousDelay = ".assistant.seriousDelay"  // 严重拖延大量任务
		
		var title: String { return self.rawValue + ".title" }
		var instruction: String { return self.rawValue + ".instruction" }
		
		var button: String?
		{
			return nil
		}
	}
	
	public func analysis() -> AssistantActionType
	{
		return AssistantActionType.firstLaunch
	}
}
