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

	public dynamic var itemComponent: ItemComponent!

	public dynamic var start: Date?

	public dynamic var end: Date?

	public dynamic var completed: Date?

	public dynamic var frequency: Int = FrequencyType.once.rawValue

	public dynamic var interval: Int = 1

	public dynamic var daysOfWeek: String?

	public dynamic var daysOfMonth: String?

	public dynamic var monthsOfYear: String?

	public dynamic var weeksOfYear: String?

	public dynamic var daysOfYear: String?

	public override class func indexedProperties() -> [String]
	{
		return ["start"]
	}

	public convenience init(component: ItemComponent, date: Date?)
	{
		self.init()
		self.itemComponent = component
	}
}
