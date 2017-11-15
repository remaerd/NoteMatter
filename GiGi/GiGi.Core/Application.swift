//
//  Application.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import CoreData

public struct Application
{
	static public var shared: Application!

	static public func start() throws
	{
		print(URL.localDatabaseDirectory)
		
		try Theme.load()
		var isFirstlaunch = true
		var isDirectory: ObjCBool = true
		if FileManager.default.fileExists(atPath: URL.localDatabaseDirectory.path, isDirectory: &isDirectory) == true, isDirectory.boolValue == true { isFirstlaunch = false }
		if isFirstlaunch { try Database.prepare() }
		Database.defaultDatabase = try Database(type: .default, modelURL: URL.defaultDatabaseModelUrl, url: URL.defaultDatabaseUrl)
	}
}
