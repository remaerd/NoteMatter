//
//  ViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class LaunchViewController: UIKit.UIViewController
{
	enum LaunchException: Error
	{
		case rootFolderNotFound
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		view.backgroundColor = UIColor(hex: "282A2E")
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		
		super.viewDidAppear(animated)
		do
		{
			try Theme.load()
			try Application.start()
			if let item = try Item.findOne(NSPredicate(format: "title == %@", Item.InternalItem.rootFolder.title))
			{
				let controller = ItemListViewController(item: item)
				self.navigationController?.setViewControllers([controller], animated: animated)
				UIApplication.shared.setStatusBarHidden(false, with: .fade)
			}
			else { throw LaunchException.rootFolderNotFound }
		} catch
		{
			error.alert()
			print(error)
		}
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

