//
//  NotificationManager.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 30/11/2017.
//

import Foundation
import UserNotifications

public class NotificationManager: NSObject
{
	enum Exception: Error
	{
		case invalidTask
	}
	
	public static var shared: NotificationManager?
	
	public static func activate(completion: @escaping (Error?) -> Void)
	{
		if #available(iOS 10.0, *)
		{
			UIApplication.shared
			NotificationManager.shared = NotificationManager()
			UNUserNotificationCenter.current().delegate = NotificationManager.shared
			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
			{ (result, error) in
				completion(error)
			}
		}
		else
		{
			// Fallback on earlier versions
		}
	}
	
	public func add(task: Task, completion: @escaping (Error?) -> Void)
	{
		let title: String
		if let item = task.item
		{
			title = item.title
		}
		else if let component = task.component, let content = component.indexedContent
		{
			title = content
		}
		else { completion(Exception.invalidTask); return }
		if #available(iOS 10.0, *)
		{
			let content = UNMutableNotificationContent()
			content.categoryIdentifier = "todo"
			content.title = title
			content.subtitle = ""
			content.body = ""
			content.badge = 1
			let request = UNNotificationRequest(identifier: task.objectID.description, content: content, trigger: nil)
			UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
				completion(error)
			})
		}
		else
		{
			let notification = UILocalNotification()
			notification.alertTitle = ""
			notification.alertBody = ""
			notification.alertAction = ""
			UIApplication.shared.scheduleLocalNotification(notification)
		}
	}
}

@available(iOS, introduced: 10.0)
extension NotificationManager: UNUserNotificationCenterDelegate
{
	public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
	{
		
	}
	
	public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
	{
		
	}
}
