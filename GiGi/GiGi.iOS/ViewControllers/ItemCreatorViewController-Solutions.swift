//
//  ItemCreatorViewController-Templates.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/1/2018.
//

import UIKit
import Cartography

class TemplateContainerView: UICollectionReusableView
{
	let controller = TemplateController()
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		
		addSubview(controller.view)
		constrain(controller.view)
		{
			view in
			view.top == view.superview!.top + Constants.statusBarHeight + Constants.searchBarHeight + Constants.edgeMargin * 2
			view.leading == view.superview!.leading + Constants.edgeMargin
			view.trailing == view.superview!.trailing - Constants.edgeMargin
			view.bottom == view.superview!.bottom - Constants.edgeMargin
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

class TemplateController: UIViewController
{
	let dashboardView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MonoDashboardCollectionLayout())
	let dashboardBar = UIView()
	
	override func loadView()
	{
		super.loadView()
		
		view.layer.cornerRadius = Constants.edgeMargin
		view.backgroundColor = Theme.colors[8]
		dashboardView.backgroundColor = UIColor.clear
		
		view.addSubview(dashboardView)
		view.addSubview(dashboardBar)
//		dashboardView.dataSource = self
//		dashboardView.delegate = self
		dashboardView.register(AssistantCell.self, forCellWithReuseIdentifier: "assistant")
		dashboardView.register(ItemCell.self, forCellWithReuseIdentifier: "task")
		
		constrain(dashboardView, dashboardBar)
		{
			view, bar in
			bar.bottom == bar.superview!.bottom
			bar.leading == bar.superview!.leading
			bar.trailing == bar.superview!.trailing
			bar.height == Constants.dashboardBarHeight
			view.top == view.superview!.top
			view.leading == view.superview!.leading
			view.trailing == view.superview!.trailing
			view.bottom == bar.top
		}
	}
}

//extension SolutionController: UICollectionViewDataSource
//{
//	func numberOfSections(in collectionView: UICollectionView) -> Int
//	{
//		return 0
//	}

//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//	{
//		let type = item!.dashboardTypes[section]
//		switch type
//		{
//		case .assistant: return 1
//		case .calendar: return 1
//		case .keyword(let keyword): if let tasks = tasks[keyword] { return tasks.count } else { return 0 }
//		default: if let tasks = tasks[type.identifier] { return tasks.count } else { return 0 }
//		}
//	}
	
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//	{
//		let type = item!.dashboardTypes[indexPath.section]
//		let cell: UICollectionViewCell
//		switch type
//		{
//		case .assistant:
//			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assistant", for: indexPath);
//			(cell as! AssistantCell).reloadItem(item: item!)
//			break
//		default:
//			let type = item!.dashboardTypes[indexPath.section].identifier
//			let task = tasks[type]![indexPath.row]
//			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath);
//			(cell as! ItemCell).alwayWhite = true
//			(cell as! ItemCell).taskDate = task.relativeDate
//			(cell as! ItemCell).titleTextfield.text = task.title
//			break
//		}
//		return cell
//	}
//}

