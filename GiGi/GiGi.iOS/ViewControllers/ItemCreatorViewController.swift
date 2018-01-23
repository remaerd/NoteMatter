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
	override var dashboardType: AnyClass? { return TemplateContainerView.self }
	override var showCloseButton: Bool { return true }
	
	let item : Item
	var templates : [Template]!
	
	init(item: Item)
	{
		self.item = item
		super.init()
		title = ".placeholder.new".localized
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		do { self.templates = try Template.findAll(nil, sortDescriptors: [NSSortDescriptor(key: "index", ascending: true)]) }
		catch { error.alert() }
		collectionView?.reloadData()
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
		collectionView?.register(TemplateContainerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "dashboard")
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
		return self.templates.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		if let image = templates[indexPath.row].icon, let icon = UIImage(named: image) { cell.icon = icon }
		cell.titleTextfield.text = self.templates[indexPath.row].title.localized
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		Sound.tapCell.play()
		let template = templates[indexPath.row]
		let item = try! Item.insert()
		item.template = template
		item.title = ".list.new".localized + template.title.localized.lowercased()
		self.item.insertIntoChildren(item, at: 0)
		
		do { try item.save() } catch { error.alert() }
		
		let index = (navigationController?.viewControllers.count)! - 2
		guard let controller = navigationController?.viewControllers[index] as? ItemListViewController else { return }
		controller.renameIndexPath = IndexPath(row: 0, section: 0)
		
		if !isSlideActionModeEnable { navigationController?.popViewController(animated: true) }
	}
}
