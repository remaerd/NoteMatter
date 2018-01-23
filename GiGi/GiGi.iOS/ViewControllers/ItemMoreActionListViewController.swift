//
//  ItemMoreActionListViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 23/1/2018.
//

import Foundation

import UIKit
import GiGi

class ItemMoreActionListViewController: UICollectionViewController
{
	override var showCloseButton: Bool { return true }
	override var pushTransition : TransitionType { return TransitionType.right }
	override var popTransition : TransitionType { return TransitionType.left }
	
	let item: Item
	
	let itemActions: [Template.ActionType]
	let publishActions: [Template.ActionType] = [.publishToPlatform, .publishToWordpress]
	let exportActions: [Template.ActionType] = [.exportAsMarkdown, .exportAsRTF, .exportAsPDF, .exportAsDocX]
	
	init(item: Item)
	{
		self.item = item
		var actions = [Template.ActionType]()
		if self.item.secret == nil { actions.append(.lock) } else { actions.append(.unlock) }
		if self.item.template.isFolder { actions.append(.convertToDocument) } else { actions.append(.convertToFolder) }
		self.itemActions = actions
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		self.title = item.title
		self.clearsSelectionOnViewWillAppear = true
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}
}

extension ItemMoreActionListViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		if self.item.template.isFolder { return 1 }
		else { return 3 }
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		switch section
		{
		case 0: return itemActions.count
		case 1: return publishActions.count
		case 2: return exportActions.count
		default: return 0
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		if let icon = item.template.actions[indexPath.row].icon { cell.icon = UIImage(named: icon) } else { cell.icon = UIImage() }
		cell.titleTextfield.text = item.template.actions[indexPath.row].title.localized
		cell.tintColor = Theme.colors[7]
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		Sound.tapCell.play()
		
		func lock()
		{
			
		}
		
		func unlock()
		{
			
		}
		
		func convertToDocument()
		{
			
		}
		
		func convertToFolder()
		{
			
		}
		
		func publishToPlatform()
		{
			
		}
		
		func publishToMedium()
		{
			
		}
		
		func publishToWordpress()
		{
			
		}
		
		func exportAsMarkdown()
		{
			
		}
		
		func exportAsRTF()
		{
			
		}
		
		func exportAsPDF()
		{
			
		}
		
		func exportAsDocX()
		{
			
		}
		
		switch item.template.actions[indexPath.row]
		{
		case .lock: lock(); break
		case .unlock: unlock(); break
		case .convertToDocument: convertToDocument(); break
		case .convertToFolder: convertToFolder(); break
		case .publishToPlatform: publishToPlatform(); break
		case .publishToWordpress: publishToWordpress(); break
		case .publishToMedium: publishToMedium(); break
		case .exportAsMarkdown: exportAsMarkdown(); break
		case .exportAsRTF: exportAsRTF(); break
		case .exportAsPDF: exportAsPDF(); break
		case .exportAsDocX: exportAsDocX(); break
		default: break
		}
	}
}

