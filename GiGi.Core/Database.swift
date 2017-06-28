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

		let folderType = LocalItemType.InternalItemType.folder
		let folderTypeItem = try LocalItemType(identifier: folderType.identifier, genre: .system)
		folderTypeItem.favouriteIndex = 0
		folderTypeItem.title = folderType.title
		folderTypeItem.icon = folderType.icon
		objects.append(folderTypeItem)

		let inboxType = LocalItemType.InternalItemType.inbox
		let inboxTypeItem = try LocalItemType(identifier: inboxType.identifier, genre: .system)
		inboxTypeItem.favouriteIndex = 0
		inboxTypeItem.title = inboxType.title
		inboxTypeItem.icon = inboxType.icon
		objects.append(inboxTypeItem)

		let documentType = LocalItemType.InternalItemType.document
		let documentTypeItem = try LocalItemType(identifier: documentType.identifier, genre: .system)
		documentTypeItem.favouriteIndex = 0
		documentTypeItem.title = documentType.title
		documentTypeItem.icon = documentType.icon
		objects.append(documentTypeItem)

		let rootFolderType = Item.InternalItem.rootFolder
		let rootFolder = Item()
		rootFolder.identifier = rootFolderType.identifier
		rootFolder.title = rootFolderType.title
		rootFolder.itemType = folderTypeItem
		objects.append(rootFolder)

		let inboxItemType = Item.InternalItem.inbox
		let inbox = Item(parent: rootFolder, itemType: inboxTypeItem, title: inboxItemType.title, identifier: inboxItemType.identifier)
		objects.append(inbox)

		let welcomeType = Item.InternalItem.welcome
		let welcome = Item(parent: rootFolder, itemType: documentTypeItem, title: welcomeType.title, identifier: welcomeType.identifier)
		objects.append(welcome)

		try self.write(
		{
			self.add(objects)
		})
	}
}
