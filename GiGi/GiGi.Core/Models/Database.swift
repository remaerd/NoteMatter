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
			let object = try LocalItemType(identifier: type.identifier, genre: .system)
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

		let welcomeType = Item.InternalItem.welcome
		let welcome = Item(parent: rootFolder, itemType: document, title: welcomeType.title, identifier: welcomeType.identifier)
		objects.append(welcome)

		try self.write({ self.add(objects) })
	}
}
