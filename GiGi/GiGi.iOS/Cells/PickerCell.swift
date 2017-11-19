//
//  PickerCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 17/11/2017.
//

import UIKit

protocol PickerCellDelegate: NSObjectProtocol
{
	func pickerCell(_ pickerCell: PickerCell, didSelect index: Int)
}

class PickerCell: Cell
{
	let pickerController = PickerController()
	weak var delegate: PickerCellDelegate?
	
	var choices = [String]() { didSet { pickerController.pickerView.reloadAllComponents() } }
	override var isSelected: Bool { didSet { didSelectedChanged() } }
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		rightView = pickerController.pickerLabel
		pickerController.pickerView.delegate = self
		pickerController.pickerView.dataSource = self
		pickerController.pickerLabel.font = Font.CellDescriptionFont
		pickerController.pickerLabel.textColor = Theme.colors[3]
		pickerController.modalPresentationStyle = .custom
		pickerController.transitioningDelegate = pickerController
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	func selectRow(_ row: Int)
	{
		pickerController.pickerLabel.text = choices[row]
		pickerController.pickerView.selectRow(row, inComponent: 0, animated: false)
	}
	
	func didSelectedChanged()
	{
		if isSelected { UIApplication.shared.keyWindow?.rootViewController?.present(pickerController, animated: true, completion: nil) }
	}
}

extension PickerCell: UIPickerViewDelegate
{
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
	{
		pickerController.pickerLabel.text = choices[row]
		delegate?.pickerCell(self, didSelect: row)
	}
}

extension PickerCell: UIPickerViewDataSource
{
	func numberOfComponents(in pickerView: UIPickerView) -> Int
	{
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
	{
		return choices.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
	{
		return choices[row]
	}
}

class PickerController: UIKit.UIViewController
{
	let pickerLabel = UILabel()
	let pickerView = UIPickerView()
	
	override func loadView()
	{
		super.loadView()
		
		view.addSubview(pickerView)
		view.backgroundColor = UIColor.clear
		pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		pickerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		pickerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		pickerView.layer.cornerRadius = Constants.defaultCornerRadius
	}
}

extension PickerController: UIViewControllerTransitioningDelegate
{
	func presentationController(forPresented presented: UIKit.UIViewController, presenting: UIKit.UIViewController?, source: UIKit.UIViewController) -> UIPresentationController?
	{
		return ModalViewController(presentedViewController: presented, presenting: presenting)
	}
}
