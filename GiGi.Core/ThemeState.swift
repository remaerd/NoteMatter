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
	public enum ThemeStatusType: Int, Equatable
	{
		case loading
		case loaded
		case invalidThemeData

		public static func == (lhs: ThemeStatusType, rhs: ThemeStatusType) -> Bool
		{
			if lhs.rawValue == rhs.rawValue { return true } else { return false }
		}
	}

	public var status : ThemeStatusType
	public var dayPallette: [UIColor]
	public var nightPallette: [UIColor]

	init()
	{
		status = .loading
		dayPallette = [UIColor]()
		nightPallette = [UIColor]()
	}
}
