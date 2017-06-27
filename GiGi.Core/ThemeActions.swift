//
//  ThemeActions.swift
//  GiGi
//
//  Created by Sean Cheng on 27/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift

public struct ThemeActions
{
	public struct Load : Action { public init() {} }

	public struct Switch : Action
	{
		var fileURL: URL
	}
}
