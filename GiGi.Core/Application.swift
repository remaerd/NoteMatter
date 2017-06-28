//
//  Application.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import RealmSwift

public struct Application
{
	public var database: Realm

	static public var shared: Application!

	static public func start() throws
	{
		try Theme.load()
		let privateDatabase = try Realm.load()
		if privateDatabase.isEmpty == true { try privateDatabase.prepare() }
	}
}
