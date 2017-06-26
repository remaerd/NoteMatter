//
//  ItemType.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import RealmSwift

public protocol ItemType
{
	var identifier: String { get set }
	var genre: Int { get set }

	var title: String? { get set }
	var introduction: String? { get set }
	var tags: String? { get set }
	var icon: String? { get set }
}

public enum ItemTypeGenre: Int
{
	case system
	case legal
	case creation
	case life
	case health
	case work
	case business
	case undefined
}

public final class LocalItemType: Object, ItemType
{
	public enum InternalItemType
	{
		case inbox
		case folder
		case document

		public var title: String
		{
			switch self
			{
			case .inbox: return "type.inbox"
			case .document: return "type.folder"
			case .folder: return "type.document"
			}
		}

		public var identifier: String
		{
			switch self
			{
			case .inbox: return "5a746576-49fd-42e2-a68f-013dc6d753ca"
			case .document: return "42882401-2194-470a-99cd-e2d271eb9891"
			case .folder: return "5f9e3523-6b0a-40e4-9963-d9dd38159a5f"
			}
		}
	}

	public dynamic var identifier: String = ""
	public dynamic var genre: Int = ItemTypeGenre.undefined.rawValue

	public dynamic var title: String?
	public dynamic var introduction: String?
	public dynamic var tags: String?
	public dynamic var icon: String?
	public dynamic var favouriteIndex: Int = 0

	public dynamic var template: Item?

	public override class func primaryKey() -> String?
	{
		return "identifier"
	}

	public override class func indexedProperties() -> [String]
	{
		return ["title", "tags"]
	}

	public convenience init(identifier: String = NSUUID().uuidString, genre: ItemTypeGenre = ItemTypeGenre.undefined) throws
	{
		self.init(value: ["identifier", identifier, "genre", genre.rawValue])
	}
}

public struct RemoteItemType: ItemType
{
	public var identifier: String = ""
	public var genre: Int = ItemTypeGenre.undefined.rawValue

	public var title: String?
	public var introduction: String?
	public var tags: String?
	public var icon: String?
	public var templateIdentifier: String
}
