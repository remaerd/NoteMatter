//
//  Task.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 14/11/2017.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject, Model
{
	public static var database: Database { return Database.standard }
	
	public var relativeDate: String?
	{
		return nil
	}
	
	public var title: String
	{
		if let item = self.item { return item.title }
		else if let component = self.component, let content = component.indexedContent { return content }
		fatalError("Invalid Task. Neither Item nor ItemComponent is linked. Should link to one at least")
	}
}
