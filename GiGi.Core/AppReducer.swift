//
//  AppReducer.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift

public func appReducer(action: Action, state: AppState?) -> AppState
{
	return AppState(database: databaseReducer(action: action, state: state?.database),
	                navigation: navigationReducer(action: action, state: state?.navigation),
	                theme: themeReducer(action: action, state: state?.theme))
}
