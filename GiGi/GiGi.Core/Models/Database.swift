//
//  Database.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public extension Realm
{
	static func load() throws -> Realm
	{
		if (!FileManager.default.fileExists(atPath: URL.localDatabaseDirectory.path))
		{
			try FileManager.default.createDirectory(at: URL.localDatabaseDirectory, withIntermediateDirectories: false, attributes: nil)
		}
		print(URL.localDatabaseDirectory)
		var configuration = Realm.Configuration()
		configuration.fileURL = URL.localDatabaseDirectory.appendingPathComponent("private.realm")
		configuration.objectTypes = [Item.self, LocalItemType.self, ItemComponent.self, Task.self]
		configuration.schemaVersion = 1
		let realm = try Realm(configuration: configuration)
		if realm.isEmpty { try realm.prepare() }
		return realm
	}

	func prepare() throws
	{
		var objects = [Object]()

		var document: LocalItemType!
		var folder: LocalItemType!
		
		for type in LocalItemType.internalTypes
		{
			let object = LocalItemType(identifier: type.identifier, genre: .system)
			object.title = type.title
			object.icon = type.icon
			objects.append(object)
			if type == .folder { folder = object } else if type == .document { document = object }
		}
		
		let rootFolderType = Item.InternalItem.rootFolder
		let rootFolder = Item()
		rootFolder.identifier = rootFolderType.identifier
		rootFolder.title = rootFolderType.title
		rootFolder.itemType = folder
		objects.append(rootFolder)

		let guidesType = Item.InternalItem.welcome
		let guide = Item(parent: rootFolder, itemType: folder, title: guidesType.title, identifier: guidesType.identifier)
		for title in [".item.welcome.1",".item.welcome.2",".item.welcome.3",".item.welcome.4",".item.welcome.5",".item.welcome.6"]
		{
			let item = Item(parent: guide, itemType: document, title: title)
			objects.append(item)
		}
		
		try self.write({ self.add(objects) })
	}
}
