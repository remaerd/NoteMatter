//
//  Item.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import RealmSwift

public final class Item: Object
{
	public enum InternalItem
	{
		case rootFolder
		case inbox
		case welcome

		public var title: String
		{
			switch self
			{
			case .inbox: return ".item.inbox"
			case .welcome: return ".item.welcome"
			case .rootFolder: return ".item.rootFolder"
			}
		}

		public var identifier: String
		{
			switch self
			{
			case .inbox: return "90ffedc9-3374-460e-914c-4862624e4d70"
			case .welcome: return "fbe2f6b3-184b-4f17-8b92-fca3003591be"
			case .rootFolder: return "97d3ce02-96f7-4a4a-88e8-7d6091291431"
			}
		}
	}

	public dynamic var identifier: String = ""

	public dynamic var itemType: LocalItemType!

	private dynamic var _title: String = ""

	public dynamic var created: Date = Date()

	public dynamic var updated: Date = Date()

	public dynamic var opened: Date = Date()

	public let components = List<ItemComponent>()

	public let children = List<Item>()

	public let parent = LinkingObjects(fromType: Item.self, property: "children")

	public var title: String
	{
		get { if String.systemItemIdentifiers.contains(identifier) { return LOCALE(_title) } else { return _title }}
		set { _title = newValue }
	}

	public override class func primaryKey() -> String?
	{
		return "identifier"
	}

	public override class func  ignoredProperties() -> [String]
	{
		return ["title"]
	}

	public override class func indexedProperties() -> [String]
	{
		return ["_title","created","updated","opened"]
	}

	public convenience init(parent: Item, itemType: LocalItemType, title: String, identifier: String = NSUUID().uuidString)
	{
		self.init()
		self.identifier = identifier
		self._title = title
		self.itemType = itemType
		parent.children.append(self)
	}
}
