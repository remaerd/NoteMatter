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
	var solutions: [LocalItemType]!
	
	override func loadView()
	{
		super.loadView()
		title = ".preferences.solutions".localized
		collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
		
		do { solutions = try LocalItemType.all() }
		catch { error.alert() }
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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
		if let image = solutions[indexPath.row].icon, let icon = UIImage(named: image) { cell.icon = icon }
		cell.titleLabel.text = solutions[indexPath.row].title.localized
		cell.actions = [.delete, .cancel]
		cell.delegate = self
		return cell
	}
}

extension SolutionListViewController: ItemCellDelegate
{
	func itemCell(_ cell: ItemCell, didTriggerAction index: Int)
	{
		func delete(solution: LocalItemType)
		{
			do { try solution.destroy() }
			catch { error.alert() }
		}
		
		let action = cell.actions![index]
		let indexPath = collectionView!.indexPath(for: cell)!
		let solution = solutions[indexPath.row]
		
		switch action
		{
		case .delete: delete(solution: solution); break
		default: break
		}
	}
}
