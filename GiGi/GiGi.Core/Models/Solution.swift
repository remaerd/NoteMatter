//
//  Solution.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 14/11/2017.
//
//

import Foundation
import CoreData

@objc(Solution)
public class Solution: NSManagedObject, Model
{
	public static var database: Database { return Database.defaultDatabase }
	
	static let internalSolutions : [Solution.InternalSolution] = [.task, .document, .folder]
	
	public enum InternalSolution
	{
		case task
		case folder
		case document
		
		public var title: String
		{
			switch self
			{
			case .task: return ".type.task"
			case .document: return ".type.document"
			case .folder: return ".type.folder"
			}
		}
		
		public var identifier: String
		{
			switch self
			{
			case .task: return "f7738220-f217-440e-9ca2-21540c7420b8"
			case .document: return "42882401-2194-470a-99cd-e2d271eb9891"
			case .folder: return "5f9e3523-6b0a-40e4-9963-d9dd38159a5f"
			}
		}
		
		public var icon: String
		{
			switch self
			{
			case .task: return "List-Todo"
			case .document: return "List-Document"
			case .folder: return "List-Folder"
			}
		}
	}
	
	public override func awakeFromInsert()
	{
		super.awakeFromInsert()
		let solution = try! Solution.find(nil, sortDescriptors: [NSSortDescriptor(key: "index", ascending: false)], properties: ["index"], limit: 1)
		if solution.count == 0 { self.index = 0 } else { index = solution[0].index + Int32(arc4random_uniform(10000)) }
	}
}
