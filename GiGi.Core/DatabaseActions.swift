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

	public struct GetItem: Action
	{
		public var identifier: String
	}
}
