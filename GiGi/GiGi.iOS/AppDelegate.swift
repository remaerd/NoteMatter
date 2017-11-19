//
//  AppDelegate.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Sentry

enum AppException: Error
{
	case internalError(message: String)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		do
		{
			Client.shared = try Client(dsn: "https://e8cf8c7637c04d7b9864d5e50d3f4d3c:ca2dc5c69b3a4b1c88be07a937c3c080@sentry.io/188692")
			try Client.shared?.startCrashHandler()
		} catch
		{
			print(error)
		}

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UINavigationController(rootViewController: LaunchViewController())
		window?.makeKeyAndVisible()
		return true
	}
}
