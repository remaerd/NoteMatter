//
//  SolutionListViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/11/2017.
//

import GiGi
import Foundation

class SolutionListViewController: UICollectionViewController
{
	let solutionIndentifiers = [Solution.InternalSolution.task.identifier,
															Solution.InternalSolution.document.identifier,
															Solution.InternalSolution.folder.identifier]
	
	var solutions: [Solution]!
	
	override func loadView()
	{
		super.loadView()
		title = ".preferences.solutions".localized
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
		collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "item")
		
		let item = UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Plus"), style: .plain, target: self, action: #selector(addButtonTapped))
		item.title = ".placeholder.solution.new".localized
		navigationItem.rightBarButtonItem = item
		do { solutions = try Solution.findAll(nil, sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)]) }
		catch { error.alert() }
	}
	
	@objc func addButtonTapped()
	{
		
	}
}


extension SolutionListViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return solutions.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell : Cell
		if solutionIndentifiers.contains(solutions[indexPath.row].identifier)
		{
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
			cell.accessoryType = .default
		}
		else
		{
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ItemCell
		}
		if let image = solutions[indexPath.row].icon, let icon = UIImage(named: image) { cell.icon = icon }
		else { cell.icon = #imageLiteral(resourceName: "0702-document")  }
		cell.titleTextfield.text = solutions[indexPath.row].title.localized
		return cell
		
	}
}

extension SolutionListViewController: ItemActionDelegate
{
	func itemActionController(forCell cell: ItemCell) -> UICollectionViewController
	{
		let indexPath = collectionView!.indexPath(for: cell)!
		return SolutionActionListViewController(solution: solutions[indexPath.row])
	}
}
