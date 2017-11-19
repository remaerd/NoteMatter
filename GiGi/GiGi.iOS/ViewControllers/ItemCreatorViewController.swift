//
//  ItemCreatorViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/11/2017.
//

import GiGi
import UIKit

class ItemCreatorViewController: UICollectionViewController
{
	let item : Item
	var solutions : [LocalItemType]!
	
	init(item: Item)
	{
		self.item = item
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		do { self.solutions = try LocalItemType.all() }
		catch { error.alert() }
		collectionView?.reloadData()
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}
}

extension ItemCreatorViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return self.solutions.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		if let image = solutions[indexPath.row].icon, let icon = UIImage(named: image) { cell.icon = icon }
		cell.titleLabel.text = self.solutions[indexPath.row].title.localized
		cell.accessoryType = .add
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		Timer.scheduledTimer(timeInterval: Constants.defaultTransitionDuration + 0.1, target: self, selector: #selector(createItem), userInfo: nil, repeats: false)
		navigationController?.popViewController(animated: true)
	}
	
	@objc func createItem()
	{
		let solution = solutions[collectionView!.indexPathsForSelectedItems![0].row]
		let item = try! Item.insert()
		item.parent = self.item
		item.type = solution
		item.title = ".list.new".localized + solution.title.localized.lowercased()
		do { try item.save() } catch { error.alert() }
	}
}
