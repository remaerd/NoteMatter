//
//  ExperienceViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/11/2017.
//

import UIKit

class ExperienceViewController: UICollectionViewController
{
	override func loadView()
	{
		super.loadView()
		title = ".preferences.experience".localized
		collectionView?.register(SwitchCell.self, forCellWithReuseIdentifier: "switcher")
		collectionView?.register(PickerCell.self, forCellWithReuseIdentifier: "picker")
		collectionView?.register(DatePickerCell.self, forCellWithReuseIdentifier: "datePicker")
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}
}

extension ExperienceViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if Defaults.themeType.int == 2 { return 5 } else { return 3 }
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		switch indexPath.row
		{
		case 0:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.switcher.addTarget(self, action: #selector(didChangeSound(switcher:)), for: .touchUpInside)
			cell.switcher.isOn = Defaults.soundEffect.bool
			cell.titleLabel.text = ".preferences.experience.sound".localized
			return cell
		case 1:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.experience.hideCompletedTasks".localized
			cell.switcher.isOn = Defaults.hideCompletedTasks.bool
			cell.switcher.addTarget(self, action: #selector(didChangeHideCompletedTasks(switcher:)), for: .touchUpInside)
			return cell
		case 2:
			let pickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "picker", for: indexPath) as! PickerCell
			pickerCell.choices = [".preferences.experience.mode.day".localized, ".preferences.experience.mode.night".localized, ".preferences.experience.mode.auto".localized]
			pickerCell.selectRow(Defaults.themeType.int)
			pickerCell.titleLabel.text = ".preferences.experience.mode".localized;
			pickerCell.delegate = self
			return pickerCell
		case 3:
			let pickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "datePicker", for: indexPath) as! DatePickerCell
			pickerCell.pickerController.pickerView.datePickerMode = .time
			pickerCell.pickerController.pickerView.date = Date()
			pickerCell.titleLabel.text = ".preferences.experience.time.day".localized
			return pickerCell
		case 4:
			let pickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "datePicker", for: indexPath) as! DatePickerCell
			pickerCell.pickerController.pickerView.datePickerMode = .time
			pickerCell.pickerController.pickerView.date = Date()
			pickerCell.titleLabel.text = ".preferences.experience.time.night".localized
			return pickerCell
		default: fatalError()
		}
	}
}

extension ExperienceViewController: PickerCellDelegate
{
	func pickerCell(_ pickerCell: PickerCell, didSelect index: Int)
	{
		Defaults.themeType.set(value: index)
		let indexPaths = [IndexPath(item: 3, section: 0),IndexPath(item: 4, section: 0)]
		if index == 2 && collectionView?.numberOfItems(inSection: 0) != 5 { collectionView?.insertItems(at: indexPaths) }
		else if index != 2 && collectionView?.numberOfItems(inSection: 0) != 3 { collectionView?.deleteItems(at: indexPaths) }
	}
	
	@objc func didChangeSound(switcher: UISwitch)
	{
		Defaults.soundEffect.set(value: switcher.isOn)
	}
	
	@objc func didChangeHideCompletedTasks(switcher: UISwitch)
	{
		Defaults.hideCompletedTasks.set(value: switcher.isOn)
	}
}
