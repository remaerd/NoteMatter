//
//  Database.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 13/11/2017.
//

import CoreData
import Foundation

public struct Database
{
	public enum Exception : Error
	{
		case InvalidModelURL
		case InvalidDatabaseURL
	}
	
	public enum StoreType
	{
		case `default`
		case memory
	}
	
	let model       : NSManagedObjectModel
	let context     : NSManagedObjectContext
	let coordinator : NSPersistentStoreCoordinator
	
	static var defaultDatabase : Database!
	
	public init(type:StoreType, modelURL: URL, url:URL?) throws
	{
		guard let model = NSManagedObjectModel(contentsOf: modelURL) else { throw Exception.InvalidModelURL }
		self.model = model
		self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
		do {
			switch type
			{
			case .default:
				guard let databaseURL = url else { throw Exception.InvalidDatabaseURL }
				try self.coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: databaseURL, options: options)
			case .memory:
				try self.coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
			}
		} catch {
			throw error
		}
		self.context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		self.context.persistentStoreCoordinator = self.coordinator
	}
}

extension Database
{
	static func prepare() throws
	{
		try FileManager.default.createDirectory(at: URL.localDatabaseDirectory, withIntermediateDirectories: false, attributes: nil)
		Database.defaultDatabase = try Database(type: .default, modelURL: URL.defaultDatabaseModelUrl, url: URL.defaultDatabaseUrl)
		
		var folderType: LocalItemType!
		var documentType: LocalItemType!
		
		for type in LocalItemType.internalTypes
		{
			let itemType = try LocalItemType.insert()
			itemType.identifier = type.identifier
			itemType.title = type.title
			itemType.icon = type.icon
			if type == .document { documentType = itemType } else if type == .folder { folderType = itemType }
		}
		
		let rootFolder = try Item.insert()
		rootFolder.identifier = Item.InternalItem.rootFolder.identifier
		rootFolder.title = Item.InternalItem.rootFolder.title
		rootFolder.type = documentType
		try rootFolder.save()
		
		let welcomeFolder = try Item.insert()
		welcomeFolder.identifier = Item.InternalItem.welcome.identifier
		welcomeFolder.title = Item.InternalItem.welcome.title
		welcomeFolder.type = folderType
		welcomeFolder.parent = rootFolder
		try welcomeFolder.save()
		
		for guide in [".item.welcome.1",".item.welcome.2",".item.welcome.3",".item.welcome.4",".item.welcome.5",".item.welcome.6"]
		{
			let guideDocument = try Item.insert()
			guideDocument.identifier = NSUUID.init().uuidString
			guideDocument.title = guide
			guideDocument.type = documentType
			guideDocument.parent = welcomeFolder
			try guideDocument.save()
		}
	}
}
