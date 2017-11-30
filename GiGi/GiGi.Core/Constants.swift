//
//  Constants.swift
//  GiGi
//
//  Created by Sean Cheng on 27/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

extension URL
{
	static let bundle = Bundle(identifier: "com.zhengxingzhi.gigi.core")!
	static let syncDatabase = URL(string: "https://localhost:9080")!
	static let localDatabaseDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.zhengxingzhi.gigi")!.appendingPathComponent("/Library/Databases")

	static let defaultDatabaseModelUrl = URL.bundle.url(forResource: "GiGi", withExtension: "momd")!
	static let defaultDatabaseUrl = URL.localDatabaseDirectory.appendingPathComponent("GiGi.sqlite")
}
