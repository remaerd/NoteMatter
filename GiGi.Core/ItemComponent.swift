//
//  ItemComponent.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import RealmSwift

public final class ItemComponent: Object
{
	public enum ComponentType: String
	{
		case body = ".components.body"
		case header1 = ".components.header1"
		case header2 = ".components.header2"
		case header3 = ".components.header3"
		case dashListItem = ".components.dashList"
		case numberedListItem = ".components.numberedList"
		case seperator = ".components.seperator"
		case codeBlock = ".components.code"
		case quote = ".components.quote"

		public var searchable : Bool
		{
			switch self
			{
			case .body: return true
			case .header1: return true
			case .header2: return true
			case .header3: return true
			case .dashListItem: return true
			case .numberedListItem: return true
			case .quote: return true
			case .codeBlock: return false
			case .seperator: return false
			}
		}
	}

	public dynamic var identifier: String = ""

	public dynamic var componentType : String = ComponentType.body.rawValue

	public dynamic var indexedContent: String?

	public dynamic var unindexedContent: String?

	// TODO: 实现“时光穿越”功能，记录内容的删除时间
//	public dynamic var deactivated: Date?

	public dynamic var hmac: String?

	public let item = LinkingObjects(fromType: Item.self, property: "components")

	public override class func primaryKey() -> String?
	{
		return "identifier"
	}

	public override class func indexedProperties() -> [String]
	{
		return ["indexedContent"]
	}

	public convenience init(item: Item, componentType: ComponentType, identifier: String = NSUUID().uuidString)
	{
		self.init()
		self.identifier = identifier
		self.componentType = componentType.rawValue
		item.components.append(self)
	}

	public var content: String?
	{
		guard let type = ComponentType.init(rawValue: self.componentType) else { return nil }
		if (type.searchable == true) { return indexedContent } else { return unindexedContent }
	}
}
