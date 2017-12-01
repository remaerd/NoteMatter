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
	
	private override init()
	{
		super.init()
	}
	
	@available(iOS 10.0, *)
	public static func activate(completion: @escaping (Error?) -> Void)
	{
		UNUserNotificationCenter.current().delegate = NotificationManager.shared
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
		{ (result, error) in
			if let error = error { completion(error) }
			if result == true
			{
				NotificationManager.shared = NotificationManager()
				completion(nil)
			}
		}
	}
	
	public static func activate()
	{
		let doneAction = UIMutableUserNotificationAction()
		doneAction.activationMode = .background
		doneAction.title = ".notification.action.done".localized
		
		let hourAction = UIMutableUserNotificationAction()
		doneAction.activationMode = .background
		doneAction.title = ".notification.action.1".localized
		
		let threeHourAction = UIMutableUserNotificationAction()
		doneAction.activationMode = .background
		doneAction.title = ".notification.action.3".localized
		
		let dayAction = UIMutableUserNotificationAction()
		doneAction.activationMode = .background
		doneAction.title = ".notification.action.24".localized
		
		let category = UIMutableUserNotificationCategory()
		category.setActions([doneAction, hourAction, threeHourAction, dayAction], for: .default)
		category.setActions([doneAction], for: .minimal)
		category.identifier = "briefing"

		let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: [category])
		UIApplication.shared.registerUserNotificationSettings(settings)
		
		NotificationManager.shared = NotificationManager()
	}
	
	public func updateBriefing()
	{
		if #available(iOS 10.0, *)
		{
			let content = UNMutableNotificationContent()
			content.categoryIdentifier = "briefing"
			content.title = "You have " + String(1) + " tasks to do today"
			content.body = "Tap and view your tasks"
		}
		else
		{
			let notification = UILocalNotification()
			notification.category = "briefing"
			notification.alertTitle = "You have " + String(1) + " tasks to do today"
			notification.alertBody = "Tap and open the app"
		}
	}
	
	public func add(task: Task, completion: @escaping (Error?) -> Void)
	{
		let title: String
		if let item = task.item { title = item.title }
		else if let component = task.component, let content = component.indexedContent { title = content }
		else { completion(Exception.invalidTask); return }
		
		if #available(iOS 10.0, *)
		{
			let content = UNMutableNotificationContent()
			content.categoryIdentifier = "todo"
			content.title = title
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
			notification.category = "todo"
			notification.alertTitle = title
			notification.alertBody = ""
			UIApplication.shared.scheduleLocalNotification(notification)
			completion(nil)
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
