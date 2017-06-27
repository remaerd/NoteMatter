//
//  DatabaseState.swift
//  GiGi
//
//  Created by Sean Cheng on 27/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift
import RealmSwift

public struct DatabaseState: StateType
{
	public enum DatabaseStatusType: Int, Equatable
	{
		case loading
		case loaded
		case firstLaunch
		case invalidDatabase

		public static func == (lhs: DatabaseStatusType, rhs: DatabaseStatusType) -> Bool
		{
			if lhs.rawValue == rhs.rawValue { return true } else { return false }
		}
	}

	public var privateDatabase: Realm?
	public var status : DatabaseStatusType
	public var caches: [String: [Object]]

	init()
	{
		status = .loading
		caches = [String: [Object]]()
	}
}
