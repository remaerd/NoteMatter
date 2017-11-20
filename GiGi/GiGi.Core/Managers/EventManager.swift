//
//  EventManager.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 20/11/2017.
//

import Foundation
import EventKit

public class EventManager
{
	public static var shared = EventManager()
	
	let store = EKEventStore.init()
	
	public var calendarStatus: EKAuthorizationStatus { return EKEventStore.authorizationStatus(for: .event) }
	public var reminderStatus: EKAuthorizationStatus { return EKEventStore.authorizationStatus(for: .reminder) }
	
	public var defaultReminderCalendar: EKCalendar?
	public var defaultEventCalendar: EKCalendar?
	
	public var reminders: [EKCalendar]?
	public var calendars: [EKCalendar]?
	
	public func activate(type: EKEntityType, completion: @escaping (_ result: Bool, _ error: Error?) -> Void)
	{
		store.requestAccess(to: type) { (result, error) in completion(result, error) }
	}
	
	public func reload()
	{
		defaultReminderCalendar = store.defaultCalendarForNewReminders()
		defaultEventCalendar = store.defaultCalendarForNewEvents
		
		if calendarStatus == .authorized
		{
			var calendars = [EKCalendar]()
			for calendar in store.calendars(for: .event) { if calendar.calendarIdentifier != defaultEventCalendar?.calendarIdentifier { calendars.append(calendar) } }
		}
		
		if reminderStatus == .authorized
		{
			var calendars = [EKCalendar]()
			for calendar in store.calendars(for: .reminder) { if calendar.calendarIdentifier != defaultEventCalendar?.calendarIdentifier { calendars.append(calendar) } }
		}
	}
}
