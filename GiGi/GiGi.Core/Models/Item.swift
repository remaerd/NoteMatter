//
//  Item.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 14/11/2017.
//
//

import Foundation
import CoreData

public protocol ItemDelegate: NSObjectProtocol
{
	func itemContentDidChanged(_ item: Item, range: NSRange)
}

@objc(Item)
public class Item: NSManagedObject, Model
{
	public static var database: Database { return Database.defaultDatabase }
	
	var cachedComponents = NSTextStorage()
	weak var delegate: ItemDelegate?
	
	public enum InternalItem
	{
		case rootFolder
		case welcome
		case thumb
		
		public var title: String
		{
			switch self
			{
			case .welcome: return ".item.welcome"
			case .thumb: return ".item.thumb"
			case .rootFolder: return ".item.rootFolder"
			}
		}
	}
	
	public enum DashboardType
	{
		case assistant
		case today
		case tomorrow
		case later
		case anytime
		case completed
		case calendar
		case keyword(keyword: String)
		
		var identifier: String
		{
			switch self
			{
			case .assistant: return ".dashboard.assistant"
			case .today: return ".dashboard.today"
			case .tomorrow: return ".dashboard.tomorrow"
			case .later: return ".dashboard.later"
			case .anytime: return ".dashboard.dashboard.anytime"
			case .completed: return ".dashboard.completed"
			case .calendar: return ".dashboard.today"
			case .keyword(let keyword): return keyword
			}
		}
	}
	
	static let internalItemTitles = [Item.InternalItem.rootFolder.title]
	static let internalItems = [Item.InternalItem.rootFolder]
	
	public override func awakeFromInsert()
	{
		super.awakeFromInsert()
		createdAt = Date()
		updatedAt = Date()
		openedAt = Date()
		
		task = try! Task.insert()
	}
}
