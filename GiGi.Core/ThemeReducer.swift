//
//  ThemeReducer.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import ReSwift
import Foundation

public func themeReducer(action: Action, state: ThemeState?) -> ThemeState
{
	var state = state ?? ThemeState()

	switch action {
	case _ as ThemeActions.Load: do { state.currentTheme = try Theme.load() } catch { state.error = error }; break
	default: break

	}

	return state
}
