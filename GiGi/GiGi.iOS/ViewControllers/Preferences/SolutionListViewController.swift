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
	var solutions: [Solution]!
	
	override func loadView()
	{
		super.loadView()
		title = ".preferences.solutions".localized
		collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
		
		do { solutions = try Solution.all([NSSortDescriptor(key: "index", ascending: true)]) }
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
