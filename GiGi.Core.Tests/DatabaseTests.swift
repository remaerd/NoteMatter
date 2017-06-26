//
//  DatabaseTests.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import XCTest
import RealmSwift

@testable import GiGi


class DatabaseTests: XCTestCase
{
	override func setUp()
	{
		super.setUp()
	}
	
	override func tearDown()
	{
		super.tearDown()
	}
	
	func testCreatePrivateDatabase()
	{
		do
		{
			var configuration = Realm.Configuration()
			configuration.objectTypes = [Item.self, ItemComponent.self, LocalItemType.self, Task.self]
			print(configuration.fileURL)
			_ = try Realm(configuration: configuration)
		}
		catch
		{
			print(error)
			XCTFail()
		}
	}
}
