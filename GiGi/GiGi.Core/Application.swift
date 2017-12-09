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
	static public var themeColor = UIColor.black
	
	static public func start() throws
	{
		print(URL.localDatabaseDirectory)

		var isFirstlaunch = true
		if FileManager.default.fileExists(atPath: URL.defaultDatabaseUrl.path) { isFirstlaunch = false }
		if isFirstlaunch { try Database.prepare() }
		Database.standard = try Database(type: .default, modelURL: URL.defaultDatabaseModelUrl, url: URL.defaultDatabaseUrl)
	}
}
