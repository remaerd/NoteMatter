//
//  NavigationReducer.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift

public func navigationReducer(action: Action, state: NavigationState?) -> NavigationState
{
	let navigationState = state ?? NavigationState()
	return navigationState
}
