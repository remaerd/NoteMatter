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
	static let localDatabaseDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!.appendingPathComponent("Databases")
	static let welcomeDocument = bundle.url(forResource: "Welcome", withExtension: "md")!
}

extension String
{
	static let systemItemType = [LocalItemType.InternalItemType.inbox,LocalItemType.InternalItemType.folder,LocalItemType.InternalItemType.document]
	static let systemItemIdentifiers = [Item.InternalItem.rootFolder.identifier, Item.InternalItem.inbox.identifier]
	static let systemItem = [Item.InternalItem.rootFolder, Item.InternalItem.inbox]
}
