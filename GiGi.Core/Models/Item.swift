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

	@objc public dynamic var identifier: String = ""

	@objc public dynamic var itemType: LocalItemType!

	@objc private dynamic var _title: String = ""

	@objc public dynamic var created: Date = Date()

	@objc public dynamic var updated: Date = Date()

	@objc public dynamic var opened: Date = Date()

	public let components = List<ItemComponent>()

	public let children = List<Item>()

	public let parent = LinkingObjects(fromType: Item.self, property: "children")

	public var title: String
	{
		get { if String.systemItemIdentifiers.contains(identifier) { return _title.localized } else { return _title }}
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

	public convenience init(parent: Item, itemType: LocalItemType, title: String, index: Int? = nil, identifier: String = NSUUID().uuidString)
	{
		self.init()
		self.identifier = identifier
		self._title = title
		self.itemType = itemType
		if let index = index { parent.children.insert(self, at: index) } else { parent.children.append(self) }
	}
}