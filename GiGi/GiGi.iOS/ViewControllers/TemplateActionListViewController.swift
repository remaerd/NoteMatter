//
//  TemplateActionListViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 26/11/2017.
//

import GiGi
import UIKit

class TemplateActionListViewController: UICollectionViewController
{
	override var showCloseButton: Bool { return true }
	override var pushTransition : TransitionType { return TransitionType.right }
	override var popTransition : TransitionType { return TransitionType.left }
	
	let template: Template
	
	init(template: Template)
	{
		self.template = template
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		self.title = template.title
		self.clearsSelectionOnViewWillAppear = true
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}
}

extension TemplateActionListViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return 2
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		let action : Template.ActionType
		switch indexPath.row
		{
		case 0: action = Template.ActionType.delete; break
		case 1: action = Template.ActionType.cancel; break
		default: fatalError()
		}
		if let icon = action.icon { cell.icon = UIImage(named: icon) } else { cell.icon = UIImage() }
		cell.titleTextfield.text = action.title.localized
		return cell
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		func deleteItem()
		{
			do { try template.destroy() } catch { error.alert() }
		}
		
		
		switch indexPath.row
		{
		case 0: deleteItem(); break
		case 1: if !isSlideActionModeEnable { navigationController?.popViewController(animated: true) }; break
		default: fatalError()
		}
	}
}

