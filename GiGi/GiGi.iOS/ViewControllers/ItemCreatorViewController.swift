//
//  ItemCreatorViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/11/2017.
//

import GiGi
import UIKit
import RealmSwift

class ItemCreatorViewController: UICollectionViewController
{
	let item : Item
	let solutions : Results<LocalItemType>
	
	init(item: Item)
	{
		self.item = item
		self.solutions = Application.shared.database.objects(LocalItemType.self)
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
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
		Application.shared.database.beginWrite()
		let item = Item(parent: self.item, itemType: solution, title: ".list.new".localized + solution.title.lowercased())
		Application.shared.database.add(item)
		do { try Application.shared.database.commitWrite() } catch { error.alert() }
	}
}
