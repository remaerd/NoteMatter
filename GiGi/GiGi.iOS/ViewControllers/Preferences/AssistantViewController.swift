//
//  AssistantViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/11/2017.
//

import UIKit

class AssistantViewController: UICollectionViewController
{
	override func loadView()
	{
		super.loadView()
		title = ".preferences.assistant".localized
		collectionView?.register(SwitchCell.self, forCellWithReuseIdentifier: "switcher")
		collectionView?.register(PickerCell.self, forCellWithReuseIdentifier: "picker")
		collectionView?.register(DatePickerCell.self, forCellWithReuseIdentifier: "datePicker")
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}
}

extension AssistantViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		if Defaults.assistantLevel.int != 2 { return 1 } else { return 2 }
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if section == 0 { return 2 }
		else { return 4 }
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		if indexPath.section == 0
		{
			switch indexPath.row
			{
			case 0:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
				cell.titleLabel.text = ".preferences.assistant".localized
				cell.switcher.isOn = Defaults.assistant.bool
				return cell
			case 1:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picker", for: indexPath) as! PickerCell
				cell.choices = [".preferences.assistant.level.loose".localized, ".preferences.assistant.level.strict".localized, ".preferences.assistant.level.custom".localized]
				cell.titleLabel.text = ".preferences.assistant.level".localized
				cell.delegate = self
				cell.selectRow(Defaults.assistantLevel.int)
				return cell
			default: fatalError()
			}
		}
		else
		{
			switch indexPath.row
			{
			case 0:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "datePicker", for: indexPath) as! DatePickerCell
				cell.titleLabel.text = ".preferences.assistant.rules.briefing".localized
				cell.pickerController.pickerView.datePickerMode = .time
				cell.pickerController.pickerView.date = Date()
				return cell
			case 1:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picker", for: indexPath) as! PickerCell
				cell.choices = [".preferences.assistant.rules.lazy.disable".localized, ".preferences.assistant.rules.lazy.month".localized, ".preferences.assistant.rules.lazy.week".localized]
				cell.titleLabel.text = ".preferences.assistant.rules.lazy".localized
				cell.delegate = self
				cell.selectRow(Defaults.assistantLazy.int)
				return cell
			case 2:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picker", for: indexPath) as! PickerCell
				cell.choices = [".preferences.assistant.rules.tooManyTasks.disable".localized, ".preferences.assistant.rules.tooManyTasks.10".localized, ".preferences.assistant.rules.tooManyTasks.3".localized]
				cell.titleLabel.text = ".preferences.assistant.rules.tooManyTasks".localized
				cell.delegate = self
				cell.selectRow(Defaults.assistantBusy.int)
				return cell
			case 3:
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picker", for: indexPath) as! PickerCell
				cell.choices = [".preferences.assistant.rules.dalay.disable".localized, ".preferences.assistant.rules.dalay.1".localized, ".preferences.assistant.rules.dalay.2".localized, ".preferences.assistant.rules.dalay.3".localized]
				cell.titleLabel.text = ".preferences.assistant.rules.dalay".localized
				cell.delegate = self
				cell.selectRow(Defaults.assistantDelay.int)
				return cell
			default: fatalError()
			}
		}
	}
}

extension AssistantViewController: PickerCellDelegate
{
	func pickerCell(_ pickerCell: PickerCell, didSelect index: Int)
	{
		let indexPath = collectionView!.indexPath(for: pickerCell)!
		if indexPath.section == 0
		{
			Defaults.assistantLevel.set(value: index)
			collectionView?.reloadData()
		}
		else
		{
			switch indexPath.row
			{
			case 1:
				Defaults.assistantLazy.set(value: index); break
			case 2:
				Defaults.assistantBusy.set(value: index); break
			case 3:
				Defaults.assistantDelay.set(value: index); break
			default: break
			}
		}
	}
}
