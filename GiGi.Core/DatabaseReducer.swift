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

	switch action
	{
	case _ as DatabaseActions.Load: do { state.privateDatabase = try Database.load() } catch { state.error = error }; break
	default: break
	}
	return state
}
