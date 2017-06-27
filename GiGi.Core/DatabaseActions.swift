//
//  DatabaseActions.swift
//  GiGi
//
//  Created by Sean Cheng on 27/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift
import RealmSwift

public struct DatabaseActions
{
	public struct Load: Action { public init() {} }
	public struct Prepare: Action{ public init() {} }

	public struct FindAll: Action
	{
		var objectType: AnyClass
		var predicates: [NSPredicate]?
	}

	public struct FindOne: Action
	{
		var objectType: AnyClass
		var identifier: String
	}

	public struct Write: Action
	{
		var object: Object
	}

	public struct BatchWrite: Action
	{
		var objects: [Object]
	}

	public struct Delete: Action
	{
		var identifier: String
	}

	public struct BatchDelete: Action
	{
		var identifiers: [String]
	}
}
