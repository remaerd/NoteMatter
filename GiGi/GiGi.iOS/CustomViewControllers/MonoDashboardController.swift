//
//  MonoDashboardController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 30/11/2017.
//

import UIKit
import GiGi
import Cartography

class MonoDashboardView: UICollectionReusableView
{
	let controller = MonoDashboardController()
	
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

class MonoDashboardCollectionLayout: UICollectionViewFlowLayout
{
	
}

class MonoDashboardController: UIViewController
{
	var item: Item? { didSet { reload() } }
	var tasks = [String: [Task]]()
	
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
	
	func reload()
	{
		if item != nil { dashboardView.reloadData() }
	}
}

extension MonoDashboardController: UICollectionViewDataSource
{
	func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return item!.dashboardTypes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		let type = item!.dashboardTypes[section]
		switch type
		{
		case .assistant: return 1
		case .calendar: return 1
		case .keyword(let keyword): return tasks[keyword]!.count
		default: return tasks[type.identifier]!.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let type = item!.dashboardTypes[indexPath.section]
		let cell: UICollectionViewCell
		switch type
		{
		case .assistant:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assistant", for: indexPath);
			break
		default:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath);
			break
		}
		return cell
	}
}

extension MonoDashboardController: UICollectionViewDelegate
{
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		
	}
}


