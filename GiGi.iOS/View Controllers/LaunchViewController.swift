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
	let imageView = UIImageView(image: #imageLiteral(resourceName: "logo.png"))
	
	enum LaunchException: Error
	{
		case rootFolderNotFound
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(hex: "282A2E")
		view.addSubview(imageView)
		
		imageView.contentMode = .center
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		
		super.viewDidAppear(animated)
		do
		{
			try Application.start()
			guard let item = Application.shared.database.objects(Item.self).filter("identifier == %@", Item.InternalItem.rootFolder.identifier).first else { throw LaunchException.rootFolderNotFound }
			
			UIView.animate(withDuration: Constants.defaultTransitionDuration, animations:
				{
					self.imageView.alpha = 0
			}, completion:
				{ (_) in
					let controller = ItemListViewController(item: item)
					self.navigationController?.setViewControllers([controller], animated: animated)
			})
		} catch
		{
			print(error)
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

