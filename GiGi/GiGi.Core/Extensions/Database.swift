//
//  Database.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 13/11/2017.
//

import CoreData
import Foundation

public enum NSManagedObjectChange
{
	case all
	case update
	case insert
	case delete
}

public typealias NSManagedObjectObserverCompletionBlock = (NSManagedObject, NSManagedObjectChange)

public class Database: NSObject
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
	
	let model       			: NSManagedObjectModel
	let context     			: NSManagedObjectContext
	let coordinator 			: NSPersistentStoreCoordinator
	var observingObjects	= [NSManagedObjectID: NSManagedObjectObserverCompletionBlock]()
	
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
		
		super.init()
	}
}
