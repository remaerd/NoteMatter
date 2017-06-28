//
//  ThemeState.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift

public struct ThemeState: StateType
{
	public var currentTheme: Theme?
	public var error: Error?
}
