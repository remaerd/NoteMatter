//
//  Item.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import RealmSwift

public protocol ItemDelegate: NSObjectProtocol
{
	func itemContentDidChanged(_ item: Item, range: NSRange)
}

public final class Item: Object
{
	public enum InternalItem
	{
		case rootFolder
		case welcome

		public var title: String
		{
			switch self
			{
			case .welcome: return ".item.welcome"
			case .rootFolder: return ".item.rootFolder"
			}
		}

		public var identifier: String
		{
			switch self
			{
			case .welcome: return "fbe2f6b3-184b-4f17-8b92-fca3003591be"
			case .rootFolder: return "97d3ce02-96f7-4a4a-88e8-7d6091291431"
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
	
	static let internalItemIdentifiers = [Item.InternalItem.rootFolder.identifier]
	static let internalItems = [Item.InternalItem.rootFolder]
	
	var cachedComponents = NSTextStorage()
	var notificationToken: NotificationToken?
	weak var delegate: ItemDelegate?
	
	@objc public dynamic var identifier: String = ""
	@objc public dynamic var itemType: LocalItemType!
	@objc public dynamic var created: Date = Date()
	@objc public dynamic var updated: Date = Date()
	@objc public dynamic var opened: Date = Date()
	@objc public dynamic var task: Task?
	
	public let components = List<ItemComponent>()

	public let children = List<Item>()
	public let parent = LinkingObjects(fromType: Item.self, property: "children")
	
	@objc private dynamic var _title: String = ""
	
	public var title: String
	{
		get { if Item.internalItemIdentifiers.contains(identifier) { return _title.localized } else { return _title }}
		set { _title = newValue }
	}
	
	@objc public dynamic var _dashboardTypes: String = ""

	public var dashboardTypes: [DashboardType]
	{
		get
		{
			let types = _dashboardTypes.split(separator: ",")
			var dashboardTypes = [DashboardType]()
			for type in types
			{
				switch type
				{
				case ".dashboard.assistant": dashboardTypes.append(DashboardType.assistant); break
				case ".dashboard.today":  dashboardTypes.append(DashboardType.today); break
				case ".dashboard.tomorrow":  dashboardTypes.append(DashboardType.tomorrow); break
				case ".dashboard.later": dashboardTypes.append(DashboardType.later); break
				case ".dashboard.dashboard.anytime":  dashboardTypes.append(DashboardType.anytime); break
				case ".dashboard.completed": dashboardTypes.append(DashboardType.completed); break
				case ".dashboard.today": dashboardTypes.append(DashboardType.calendar); break
				default: dashboardTypes.append(DashboardType.keyword(keyword: String(type))); break
				}
			}
			return dashboardTypes
		}
		set
		{
			var types = [String]()
			for type in dashboardTypes { types.append(type.identifier) }
			_dashboardTypes = types.joined(separator: ",")
		}
	}
	
	public override class func primaryKey() -> String?
	{
		return "identifier"
	}

	public override class func indexedProperties() -> [String]
	{
		return ["_title","created","updated","opened", "cachedComponents"]
	}

	public convenience init(parent: Item, itemType: LocalItemType, title: String, index: Int? = nil, identifier: String = NSUUID().uuidString)
	{
		self.init()
		self.dashboardTypes = [.assistant, .today, .later, .anytime]
		self.identifier = identifier
		self.itemType = itemType
		self.title = title
		self.task = Task()
		if let index = index { parent.children.insert(self, at: index) } else { parent.children.append(self) }
	}
}
