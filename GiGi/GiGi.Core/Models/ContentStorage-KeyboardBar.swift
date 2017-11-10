//
//  ContentStorage-KeyboardBar.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 19/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

public extension ContentStorage
{
	public func setParagraphStyle(style: ItemComponent.ComponentType) throws
	{
		guard let range = selectedRange else { return }
		guard let components = item.components(range: range) else { return }
		Application.shared.database.beginWrite()
		for component in components { component.componentType = style }
		try Application.shared.database.commitWrite()
	}
	
	public func toggleTask() throws
	{
		guard let range = selectedRange else { return }
		guard let components = item.components(range: range) else { return }
		Application.shared.database.beginWrite()
		for component in components
		{
			var add = false
			if let _ = components.first?.task.first { add = true }
			if !add
			{
				guard let task = component.task.first else { break }
				Application.shared.database.delete(task)
			} else
			{
				if let _ = component.task.first { break }
				let task = Task(component: component, date: nil)
				Application.shared.database.add(task)
			}
		}
		try Application.shared.database.commitWrite()
	}
	
	public func setInlineStyle(style: ItemComponent.ComponentInnerStyle) throws
	{
		//		guard let components = selectedComponents else { return }
		//		Application.shared.database.beginWrite()
	}
	
	public func setLink(url: URL?) throws
	{
		
	}
	
	public func setBrace(string: String) throws
	{
		
	}
	
	public func setSingleQuote(string: String) throws
	{
		
	}
	
	public func setPunctuation(string: String) throws
	{
		
	}
}

