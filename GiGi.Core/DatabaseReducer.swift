//
//  DatabaseReducer.swift
//  GiGi
//
//  Created by Sean Cheng on 27/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift
import RealmSwift

public func databaseReducer(action: Action, state: DatabaseState?) -> DatabaseState
{
	var state = state ?? DatabaseState()

	func load()
	{
		do
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
			state.privateDatabase = realm
			if realm.isEmpty { state.status = .firstLaunch } else { state.status = .loaded }
		} catch
		{
			state.status = .invalidDatabase
		}
	}

	func prepare()
	{
		do
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

			try state.privateDatabase?.write(
			{
				state.privateDatabase?.add(objects)
			})

			state.status = .loaded
		} catch { state.status = .invalidDatabase }
	}

	func findAll(type: AnyClass)
	{

	}

	func findOne(type: AnyClass, identifier: String)
	{

	}

	func write(object: Object)
	{

	}

	func batchWrite(objects: [Object])
	{

	}

	switch action
	{
	case _ as DatabaseActions.Load: load()
	case _ as DatabaseActions.Prepare: prepare()
	case let action as DatabaseActions.FindOne: findOne(type: action.objectType, identifier: action.identifier)
	case let action as DatabaseActions.FindAll: findAll(type: action.objectType)
	case let action as DatabaseActions.Write:  write(object: action.object)
	case let action as DatabaseActions.BatchWrite: batchWrite(objects: action.objects)
	default: break
	}
	return state
}
