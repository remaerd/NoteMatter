//
//  Task.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import RealmSwift

public final class Task: Object
{
	public enum FrequencyType: Int
	{
		case once
		case daily
		case weekly
		case monthly
		case yearly
	}

	@objc public dynamic var start: Date?

	@objc public dynamic var end: Date?

	@objc public dynamic var completed: Date?

	@objc public dynamic var frequency: Int = FrequencyType.once.rawValue

	@objc public dynamic var interval: Int = 1

	@objc public dynamic var daysOfWeek: String?

	@objc public dynamic var daysOfMonth: String?

	@objc public dynamic var monthsOfYear: String?

	@objc public dynamic var weeksOfYear: String?

	@objc public dynamic var daysOfYear: String?

	@objc public dynamic var location: Data?
	
	public let item = LinkingObjects(fromType: Item.self, property: "task")
	
	public let itemComponent = LinkingObjects(fromType: ItemComponent.self, property: "task")
	
	public override class func indexedProperties() -> [String] { return ["start"] }
}
