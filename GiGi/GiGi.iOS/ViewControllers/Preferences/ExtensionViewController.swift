//
//  ExtensionViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/11/2017.
//

import GiGi
import UIKit

class ExtensionViewController: UICollectionViewController
{
	override func loadView()
	{
		super.loadView()

		title = ".preferences.extensions".localized
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
		collectionView?.register(SwitchCell.self, forCellWithReuseIdentifier: "switcher")
	}
}

extension ExtensionViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if #available(*, iOS 11.0) { return 6 } else { return 5 }
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		switch indexPath.row
		{
		case 0:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
			cell.titleLabel.text = ".preferences.extensions.today".localized
			cell.accessoryType = Cell.AccessoryType.description(string: ".preferences.extensions.inactived".localized)
			cell.icon = #imageLiteral(resourceName: "List-Today")
			return cell
		case 1:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
			cell.titleLabel.text = ".preferences.extensions.share".localized
			cell.accessoryType = Cell.AccessoryType.description(string: ".preferences.extensions.inactived".localized)
			cell.icon = #imageLiteral(resourceName: "List-Share")
			return cell
		case 2:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.reminders".localized
			cell.switcher.addTarget(self, action: #selector(didTappedReminderSwitch(switcher:)), for: .touchUpInside)
			if Defaults.extensionReminder.bool && EventManager.shared.reminderStatus == .authorized { cell.switcher.isOn = true }
			cell.icon = #imageLiteral(resourceName: "List-Reminders")
			return cell
		case 3:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.calendar".localized
			cell.switcher.addTarget(self, action: #selector(didTappedCalendarSwitch(switcher:)), for: .touchUpInside)
			if Defaults.extensionCalendar.bool && EventManager.shared.calendarStatus == .authorized { cell.switcher.isOn = true }
			cell.icon = #imageLiteral(resourceName: "List-Calendar")
			return cell
		case 4:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.spotlight".localized
			cell.switcher.addTarget(self, action: #selector(didTappedSpotlightSwitch(switcher:)), for: .touchUpInside)
			cell.switcher.isOn = Defaults.extensionSpotlight.bool
			cell.icon = #imageLiteral(resourceName: "List-Spotlight")
			return cell
		case 5:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.siri".localized
			if #available(iOS 11.0, *) { cell.switcher.addTarget(self, action: #selector(didTappedSiriSwitch(switcher:)), for: .touchUpInside) }
			if Defaults.extensionSiri.bool && EventManager.shared.calendarStatus == .authorized { cell.switcher.isOn = true }
			cell.icon = #imageLiteral(resourceName: "List-Siri")
			return cell
		default: fatalError()
		}
	}
}

extension ExtensionViewController
{
	@objc func didTappedReminderSwitch(switcher: UISwitch)
	{
		func disable()
		{
			switcher.isOn = false
			Defaults.extensionReminder.set(value: false)
			self.alert(title: ".preferences.extensions.reminders.alert.title".localized, message: ".preferences.extensions.reminders.alert.description".localized)
		}
		
		func ask()
		{
			EventManager.shared.activate(type: .reminder, completion:
			{ (result, error) in
				OperationQueue.main.addOperation
				{
					if result == false { disable(); return }
					Defaults.extensionReminder.set(value: true)
					switcher.isOn = result
				}
				
			})
		}
		
		if !switcher.isOn { Defaults.extensionReminder.set(value: false) }
		else
		{
			switch EventManager.shared.reminderStatus
			{
			case .authorized: Defaults.extensionReminder.set(value: true); break
			case .notDetermined: ask(); break
			default: disable(); break
			}
		}
	}
	
	@objc func didTappedCalendarSwitch(switcher: UISwitch)
	{
		func disable()
		{
			switcher.isOn = false
			Defaults.extensionCalendar.set(value: false)
			self.alert(title: ".preferences.extensions.calendar.alert.title".localized, message: ".preferences.extensions.calendar.alert.description".localized)
		}
		
		func ask()
		{
			EventManager.shared.activate(type: .event, completion:
			{ (result, error) in
				OperationQueue.main.addOperation
				{
					if result == false { disable(); return }
					Defaults.extensionCalendar.set(value: true)
					switcher.isOn = result
				}
				
			})
		}
		
		if !switcher.isOn { Defaults.extensionCalendar.set(value: false) }
		else
		{
			switch EventManager.shared.calendarStatus
			{
			case .authorized: Defaults.extensionCalendar.set(value: true); break
			case .notDetermined: ask(); break
			default: disable(); break
			}
		}
	}
	
	@available(iOS, introduced: 11.0)
	@objc func didTappedSiriSwitch(switcher: UISwitch)
	{
		func disable()
		{
			switcher.isOn = false
			Defaults.extensionSiri.set(value: false)
			self.alert(title: ".preferences.extensions.siri.alert.title".localized, message: ".preferences.extensions.siri.alert.description".localized)
		}
		
		func ask()
		{
			SiriManager.shared.activate( completion:
			{(status) in
				OperationQueue.main.addOperation
				{
					if status != .authorized { disable(); return }
					Defaults.extensionCalendar.set(value: true)
					switcher.isOn = true
				}
			})
		}
		
		if !switcher.isOn { Defaults.extensionSiri.set(value: false) }
		else
		{
			switch SiriManager.shared.status
			{
			case .authorized:
				Defaults.extensionSiri.set(value: switcher.isOn); break
			case .notDetermined:
				ask(); break
			default: disable();
				break
			}
		}
	}
	
	@objc func didTappedSpotlightSwitch(switcher: UISwitch)
	{
		Defaults.extensionSpotlight.set(value: switcher.isOn)
	}
}


