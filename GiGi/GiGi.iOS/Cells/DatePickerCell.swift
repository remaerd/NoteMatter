//
//  DatePickerCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 18/11/2017.
//

import UIKit
import Cartography

class DatePickerCell: Cell
{
	let pickerController = DatePickerController()
	
	override var isSelected: Bool { didSet { didSelectedChanged() } }
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		
		rightView = pickerController.pickerLabel
		pickerController.pickerLabel.text = pickerController.pickerView.date.timeString(in: .short)
		pickerController.pickerLabel.font = Font.CellDescriptionFont
		pickerController.pickerLabel.textColor = Theme.colors[3]
		
		pickerController.modalPresentationStyle = .custom
		pickerController.transitioningDelegate = pickerController
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	func didSelectedChanged()
	{
		if isSelected
		{
			UIApplication.shared.keyWindow?.rootViewController?.present(pickerController, animated: true, completion: nil)
		}
	}
}

class DatePickerController: UIKit.UIViewController
{
	let pickerLabel = UILabel()
	let pickerView = UIDatePicker()
	
	override func loadView()
	{
		super.loadView()
		
		view.backgroundColor = UIColor.clear
		
		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.layer.cornerRadius = Constants.defaultCornerRadius
		blurView.clipsToBounds = true
		view.addSubview(blurView)
		blurView.contentView.addSubview(pickerView)
		
		constrain(blurView, pickerView)
		{
			view, pickerView in
			view.leading == view.superview!.leading + Constants.edgeMargin
			view.trailing == view.superview!.trailing - Constants.edgeMargin
			view.top == view.superview!.top + ( UIScreen.main.bounds.height - Constants.edgeMargin - Defaults.listHeight.float )
			view.bottom == view.superview!.bottom - Constants.edgeMargin
			pickerView.edges == view.edges
		}
	}
	
	@objc func didChangeDate()
	{
		pickerLabel.text = pickerView.date.timeString(in: .short)
	}
}

extension DatePickerController: UIViewControllerTransitioningDelegate
{
	func presentationController(forPresented presented: UIKit.UIViewController, presenting: UIKit.UIViewController?, source: UIKit.UIViewController) -> UIPresentationController?
	{
		return ModalViewController(presentedViewController: presented, presenting: presenting)
	}
}

