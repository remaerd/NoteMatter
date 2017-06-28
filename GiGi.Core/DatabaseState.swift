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
	public var privateDatabase: Realm?
	public var error: Error?
}
