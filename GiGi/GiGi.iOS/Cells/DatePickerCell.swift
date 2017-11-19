//
//  DatePickerCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 18/11/2017.
//

import UIKit

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
		if isSelected { UIApplication.shared.keyWindow?.rootViewController?.present(pickerController, animated: true, completion: nil) }
	}
}

class DatePickerController: UIKit.UIViewController
{
	let pickerLabel = UILabel()
	let pickerView = UIDatePicker()
	
	override func loadView()
	{
		super.loadView()
		
		view.addSubview(pickerView)
		view.backgroundColor = UIColor.clear
		pickerView.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
		pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		pickerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		pickerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		pickerView.layer.cornerRadius = Constants.defaultCornerRadius
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

