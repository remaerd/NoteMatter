//
//  NotificationViewController.swift
//  Notification
//
//  Created by Sean Cheng on 30/11/2017.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UITableViewController, UNNotificationContentExtension
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any required interface initialization here.
	}
	
	func didReceive(_ notification: UNNotification)
	{
		
	}
	
	func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void)
	{
		
	}
}
