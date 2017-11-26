//
//  Database.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation
import CoreData

public protocol Model
{
	static var database: Database { get }
}

public enum NSManagedObjectException : Error
{
	case cannotCreateObject
	case invalidDatabase
	case invalidModelType
	case invalidSearchPredicate
	case invalidDataType
}

public extension Model where Self : NSManagedObject
{
	public static func count(_ options: AnyObject? = nil, entityName: String? = nil) throws -> Int
	{
		let predicate : NSPredicate? = self.predicate(options)
		let request = self.fetchRequest(entityName)
		request.predicate = predicate
		let result = try self.database.context.count(for: request)
		return result
	}
	
	public static func all(_ sortDescriptors: [NSSortDescriptor]? = nil, properties: [String]? = nil, entityName: String? = nil) throws -> [Self]
	{
		let request = self.fetchRequest(entityName)
		do {
			return try self.database.context.fetch(request)
		} catch {
			throw error
		}
	}
	
	public static func search(_ keyword:String, fields: [String], sortDescriptors: [NSSortDescriptor]? = nil, properties: [String]? = nil, database: Database, entityName: String? = nil) throws -> [Self]
	{
		do {
			let predicate : NSPredicate? = self.searchPredicate(keyword, fields: fields)
			if predicate == nil { throw NSManagedObjectException.invalidSearchPredicate }
			return try self.find(predicate, sortDescriptors: sortDescriptors, properties: properties, limit: 1, entityName: entityName)
		} catch {
			throw error
		}
	}
	
	public static func findOne(_ options: AnyObject, sortDescriptors: [NSSortDescriptor]? = nil, properties: [String]? = nil, entityName: String? = nil) throws -> Self?
	{
		let predicate : NSPredicate? = self.predicate(options)
		do {
			let packages = try self.find(predicate, sortDescriptors: sortDescriptors, properties: properties, limit: 1, entityName: entityName)
			return packages.first
		} catch {
			throw error
		}
	}
	
	
	public static func findAll(_ options: AnyObject?, sortDescriptors: [NSSortDescriptor]? = nil, properties: [String]? = nil, entityName: String? = nil) throws -> [Self]
	{
		do {
			let predicate : NSPredicate? = self.predicate(options)
			return try self.find(predicate, sortDescriptors: sortDescriptors, properties: properties, entityName: entityName)
		} catch {
			throw error
		}
	}
	
	
	public static func find(_ predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil, properties: [String]? = nil, limit: Int = 0, entityName: String? = nil) throws -> [Self]
	{
		let request = self.fetchRequest(entityName)
		request.fetchLimit = limit
		request.sortDescriptors = sortDescriptors
		request.propertiesToFetch = properties
		request.predicate = predicate
		do { return try self.database.context.fetch(request) } catch { throw error }
	}
}


public extension Model where Self : NSManagedObject
{
	// Create new Object
	public static func insert(_ database: Database? = nil, entityName: String? = nil) throws -> Self
	{
		let entity : String
		if entityName != nil { entity = entityName! }
		else { entity = self.entityName() }
		guard let item = NSEntityDescription.insertNewObject(forEntityName: entity, into: self.database.context) as? Self else {
			throw NSManagedObjectException.cannotCreateObject
		}
		return item
	}
	
	// Save
	public func save() throws
	{
		do { try self.managedObjectContext?.save()	}
		catch { throw error }
	}
	
	// Delete
	public func destroy() throws
	{
		self.managedObjectContext?.delete(self)
		do {
			try self.managedObjectContext?.save()
		} catch {
			throw error
		}
	}
}

public extension Model where Self: NSManagedObject
{
	public func addObserver(handler: @escaping NSManagedObjectChangeHandler)
	{
		Self.database.observingObjects[self.objectID] = handler
	}
	
	public func removeObserver()
	{
		Self.database.observingObjects.removeValue(forKey: self.objectID)
	}
}


public extension Model where Self : NSManagedObject
{
	public static func searchPredicate(_ keyword:String, fields: [String]) -> NSPredicate?
	{
		var predicates = [NSPredicate]()
		var fieldExpressions = [NSExpression]()
		for field in fields { fieldExpressions.append(NSExpression(format: field)) }
		
		let keywords = keyword.components(separatedBy: " ").filter
		{ (element) -> Bool in
			if element == "" { return false }
			return true
		}
		
		for keyword in keywords
		{
			let keywordExpression = NSExpression(format: "\"\(keyword)\"")
			var keywordPredicates = [NSPredicate]()
			for fieldExpression in fieldExpressions
			{
				let predicate = NSComparisonPredicate(leftExpression: fieldExpression, rightExpression: keywordExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
				keywordPredicates.append(predicate)
			}
			let keywordPredicate = NSCompoundPredicate(type: .or, subpredicates: keywordPredicates)
			predicates.append(keywordPredicate)
		}
		
		if predicates.count == 1 { return predicates[0] }
		else if predicates.count > 1 { return NSCompoundPredicate(type: .and, subpredicates: predicates) }
		else { return nil }
	}
	
	
	fileprivate static func predicate(_ options: AnyObject?) -> NSPredicate?
	{
		if options == nil { return nil }
		var result : NSPredicate?
		if let predicate = options as? NSPredicate { result = predicate }
		else if let dictionary = options as? [String:AnyObject]
		{
			var predicateString : String?
			var predicateValues = [AnyObject]()
			for (key,value) in dictionary
			{
				if predicateString == nil { predicateString = "\(key) == %@" }
				else { predicateString = "\(String(describing: predicateString)) && \(key) == %@" }
				predicateValues.append(value)
			}
			result = NSPredicate(format: predicateString!, argumentArray: predicateValues)
		}
		return result
	}
	
	fileprivate static func entityName() -> String
	{
		let classNames = NSStringFromClass(self).components(separatedBy: ".")
		let className = classNames.last!
		return className
	}
	
	fileprivate static func fetchRequest(_ entityName: String? = nil) -> NSFetchRequest<Self>
	{
		let entity : String
		if entityName != nil { entity = entityName! }
		else { entity = self.entityName() }
		let request = NSFetchRequest<Self>(entityName: entity)
		request.returnsObjectsAsFaults = false
		return request
	}
}

