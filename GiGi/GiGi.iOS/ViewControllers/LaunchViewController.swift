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
			try Application.start()
			guard let item = Application.shared.database.objects(Item.self).filter("identifier == %@", Item.InternalItem.rootFolder.identifier).first else { throw LaunchException.rootFolderNotFound }
			
			let controller = ItemListViewController(item: item)
			self.navigationController?.setViewControllers([controller], animated: animated)
		} catch
		{
			error.alert()
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		return UIStatusBarStyle.lightContent
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

