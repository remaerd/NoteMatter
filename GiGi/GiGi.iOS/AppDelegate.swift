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

	func initialize()
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
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		initialize()
		return true
	}
	
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool
	{
		initialize()
		return true
	}
}

extension AppDelegate
{
	func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
	{
		
	}
	
	func application(_ application: UIApplication, didReceive notification: UILocalNotification)
	{
		
	}
	
	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void)
	{
		
	}
	
	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)
	{
		
	}
}

extension AppDelegate
{
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
	{
		
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
	{
		
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
	{
		
	}
	
	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)
	{
		
	}
	
	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)
	{
		
	}
}
