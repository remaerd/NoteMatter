//
//  ItemCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/11/2017.
//

import GiGi
import UIKit

@objc protocol ItemCellDelegate: NSObjectProtocol
{
	@objc optional func itemCell(_ cell:ItemCell, didTriggerAction index: Int)
}

class ItemCell: Cell
{
	enum ItemType
	{
		case `default`
		case folder
		case secretFolder
	}
	
	var slideTransition: SlideTransition
	{
		let delegate = UIApplication.shared.delegate as? AppDelegate
		let navController = delegate?.window?.rootViewController as? UINavigationController
		return navController!.slideTransition
	}
	
	var itemType: ItemType = .default
	{
		didSet
		{
			switch itemType
			{
			case .default:
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Document-Uncheck"), for: .normal)
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Document-Checked"), for: .selected)
				break
			case .folder:
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Folder-Uncheck"), for: .normal)
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Folder-Checked"), for: .selected)
				break
			case .secretFolder:
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Folder-Lock"), for: .normal)
				break
			}
		}
	}
	
	var actions: [ActionType]? = nil { didSet { setActions() } }
	var taskButton = UIButton()
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		let pan = UIPanGestureRecognizer(target: self, action: #selector(itemCellDidPanned(gesture:)))
		pan.maximumNumberOfTouches = 1
		pan.minimumNumberOfTouches = 1
		pan.delegate = self
		addGestureRecognizer(pan)
		leftView = taskButton
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse()
	{
		// 忽略原来的 Cell 会删掉 LeftView 和 RightView
		return
	}
	
	func setActions()
	{
		guard let _ = actions else { rightView = nil; return }
		let button = UIButton(frame: frame)
		button.setImage(#imageLiteral(resourceName: "Accessory-Action"), for: .normal)
		button.addTarget(self, action: #selector(didTappedAccessoryButton), for: .touchUpInside)
		rightView = button
	}
}

extension ItemCell: UIGestureRecognizerDelegate
{
	@objc func didTappedAccessoryButton()
	{
		self.slideTransition.itemCellDidTappedAccessoryView(cell: self)
	}
	
	@objc func itemCellDidPanned(gesture: UIPanGestureRecognizer)
	{
		self.slideTransition.itemCellDidPanned(gesture: gesture)
	}
	
	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
	{
		if let gesture = gestureRecognizer as? UIPanGestureRecognizer
		{
			let translation = gesture.translation(in: self.superview!)
			if (fabs(translation.x) / fabs(translation.y) <= 1) { return false }
			self.slideTransition.itemCell = self
			return true
		}
		return false
	}
}
