//
//  AppState.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift

public struct AppState: StateType
{
	public var database: DatabaseState
	public var navigation: NavigationState
	public var theme: ThemeState
}
