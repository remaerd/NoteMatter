//
//  ItemListViewController-Dashboard.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/1/2018.
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

class MonoDashboardCollectionLayout: UIKit.UICollectionViewFlowLayout
{
	override init()
	{
		super.init()
		minimumLineSpacing = 0
		minimumInteritemSpacing = 0
		scrollDirection = .horizontal
		sectionInset = UIEdgeInsets(top: Constants.edgeMargin, left: Constants.edgeMargin, bottom: Constants.edgeMargin, right: Constants.edgeMargin)
	}
	
	override func prepare()
	{
		super.prepare()
		guard let collectionView = self.collectionView else { return }
		estimatedItemSize = CGSize(width: collectionView.bounds.width - Constants.edgeMargin * 2, height: Constants.cellHeight)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
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
		dashboardView.dataSource = self
		dashboardView.delegate = self
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
		if let item = item { return item.dashboardTypes.count }
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		let type = item!.dashboardTypes[section]
		switch type
		{
		case .assistant: return 1
		case .calendar: return 1
		case .keyword(let keyword): if let tasks = tasks[keyword] { return tasks.count } else { return 0 }
		default: if let tasks = tasks[type.identifier] { return tasks.count } else { return 0 }
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
			(cell as! AssistantCell).reloadItem(item: item!)
			break
		default:
			let type = item!.dashboardTypes[indexPath.section].identifier
			let task = tasks[type]![indexPath.row]
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath);
			(cell as! ItemCell).alwayWhite = true
			(cell as! ItemCell).taskDate = task.relativeDate
			(cell as! ItemCell).titleTextfield.text = task.title
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

