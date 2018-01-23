//
//  Model.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 14/11/2017.
//

import CoreData

public extension Item
{
	@NSManaged public var title: String
	@NSManaged public var createdAt: Date
	@NSManaged public var updatedAt: Date
	@NSManaged public var openedAt: Date
	
	@NSManaged public var task: Task
	@NSManaged public var template: Template
	@NSManaged public var dashboardType: String
	
	@NSManaged public var parent: Item?
	@NSManaged public var children: [Item]?
	
	@NSManaged public var secret: Data?
	@NSManaged public var hmac: Data?
	
	@NSManaged public var components: [ItemComponent]
}

// MARK: Generated accessors for children
extension Item
{
	@objc(insertObject:inChildrenAtIndex:)
	@NSManaged public func insertIntoChildren(_ value: Item, at idx: Int)
	
	@objc(removeObjectFromChildrenAtIndex:)
	@NSManaged public func removeFromChildren(at idx: Int)
	
	@objc(insertChildren:atIndexes:)
	@NSManaged public func insertIntoChildren(_ values: [Item], at indexes: NSIndexSet)
	
	@objc(removeChildrenAtIndexes:)
	@NSManaged public func removeFromChildren(at indexes: NSIndexSet)
	
	@objc(replaceObjectInChildrenAtIndex:withObject:)
	@NSManaged public func replaceChildren(at idx: Int, with value: Item)
	
	@objc(replaceChildrenAtIndexes:withChildren:)
	@NSManaged public func replaceChildren(at indexes: NSIndexSet, with values: [Item])
	
	@objc(addChildrenObject:)
	@NSManaged public func addToChildren(_ value: Item)
	
	@objc(removeChildrenObject:)
	@NSManaged public func removeFromChildren(_ value: Item)
	
	@objc(addChildren:)
	@NSManaged public func addToChildren(_ values: NSOrderedSet)
	
	@objc(removeChildren:)
	@NSManaged public func removeFromChildren(_ values: NSOrderedSet)
}

// MARK: Generated accessors for components
extension Item
{
	@objc(insertObject:inComponentsAtIndex:)
	@NSManaged public func insertIntoComponents(_ value: ItemComponent, at idx: Int)
	
	@objc(removeObjectFromComponentsAtIndex:)
	@NSManaged public func removeFromComponents(at idx: Int)
	
	@objc(insertComponents:atIndexes:)
	@NSManaged public func insertIntoComponents(_ values: [ItemComponent], at indexes: NSIndexSet)
	
	@objc(removeComponentsAtIndexes:)
	@NSManaged public func removeFromComponents(at indexes: NSIndexSet)
	
	@objc(replaceObjectInComponentsAtIndex:withObject:)
	@NSManaged public func replaceComponents(at idx: Int, with value: ItemComponent)
	
	@objc(replaceComponentsAtIndexes:withComponents:)
	@NSManaged public func replaceComponents(at indexes: NSIndexSet, with values: [ItemComponent])
	
	@objc(addComponentsObject:)
	@NSManaged public func addToComponents(_ value: ItemComponent)
	
	@objc(removeComponentsObject:)
	@NSManaged public func removeFromComponents(_ value: ItemComponent)
	
	@objc(addComponents:)
	@NSManaged public func addToComponents(_ values: NSOrderedSet)
	
	@objc(removeComponents:)
	@NSManaged public func removeFromComponents(_ values: NSOrderedSet)
}

extension Template
{
	@NSManaged public var identifier: String
	@NSManaged public var title: String
	@NSManaged public var introduction: String?
	@NSManaged public var tags: String?
	
	@NSManaged public var index: Int32
	@NSManaged public var genre: Int16
	@NSManaged public var icon: String?
	@NSManaged public var isFolder: Bool
}


extension ItemComponent
{
	@NSManaged public var type: String
	@NSManaged public var innerStyles: NSObject?
	
	@NSManaged public var indexedContent: String?
	@NSManaged public var unindexedContent: NSData?
	
	@NSManaged public var item: Item
	@NSManaged public var task: Task?
}

extension Task
{
	@NSManaged public var startAt: Date?
	@NSManaged public var endAt: Date?
	@NSManaged public var completedAt: Date?
	
	@NSManaged public var daysOfMonth: String?
	@NSManaged public var daysOfWeek: String?
	@NSManaged public var daysOfYear: String?
	@NSManaged public var frequency: Int16
	@NSManaged public var interval: Int16
	@NSManaged public var location: NSObject?
	@NSManaged public var monthsOfYear: String?

	@NSManaged public var weeksOfYear: String?
	@NSManaged public var component: ItemComponent?
	@NSManaged public var item: Item?
}
