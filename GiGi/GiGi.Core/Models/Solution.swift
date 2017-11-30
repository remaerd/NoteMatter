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
	public enum ActionType
	{
		case reschedule
		case move
		case rename
		case convert
		case delete
		case cancel
		
		public var icon: String?
		{
			switch self
			{
			case .reschedule: return "List-Bell"
			case .move: return "List-Move"
			case .rename: return "List-Rename"
			case .convert: return "List-Convert"
			case .delete: return "List-Delete"
			case .cancel: return nil
			}
		}
		
		public var title: String
		{
			switch self
			{
			case .reschedule: return ".list.actions.reschedule".localized
			case .rename: return ".list.actions.rename".localized
			case .move: return ".list.actions.move".localized
			case .convert: return ".list.actions.convert".localized
			case .delete: return ".list.actions.delete".localized
			case .cancel: return ".universal.cancel".localized
			}
		}
	}
	
	public static var database: Database { return Database.defaultDatabase }
	
	public static let internalSolutions : [Solution.InternalSolution] = [.task, .document, .folder]
	
	public enum InternalSolution
	{
		case task
		case folder
		case document
		case problem
		case diary
		case habit
		
		public var title: String
		{
			switch self
			{
			case .task: return ".type.task"
			case .document: return ".type.document"
			case .folder: return ".type.folder"
			case .problem: return ".type.problem"
			case .diary: return ".type.diary"
			case .habit: return ".type.habit"
			}
		}
		
		public var identifier: String
		{
			switch self
			{
			case .task: return "f7738220-f217-440e-9ca2-21540c7420b8"
			case .document: return "42882401-2194-470a-99cd-e2d271eb9891"
			case .folder: return "5f9e3523-6b0a-40e4-9963-d9dd38159a5f"
			case .problem: return "259144ad-835c-45f0-8ba8-2cbf5de572ba"
			case .diary: return "b3ffef87-828b-45b1-a496-56718b57b711"
			case .habit: return "da5d93dd-b7b7-4183-a085-f986304d8354"
			}
		}
		
		public var icon: String
		{
			switch self
			{
			case .task: return "0302-circlecheckmark"
			case .document: return "0702-document"
			case .folder: return "0801-folder"
			case .diary: return "0703-bookclosed"
			case .problem: return "0312-report"
			case .habit: return "1304-tulip"
			}
		}
	}
	
	public override func awakeFromInsert()
	{
		super.awakeFromInsert()
		let solution = try! Solution.find(nil, sortDescriptors: [NSSortDescriptor(key: "index", ascending: false)], properties: ["index"], limit: 1)
		if solution.count == 0 { self.index = 0 } else { index = solution[0].index + Int32(arc4random_uniform(10000)) }
	}
	
	public var actions: [ActionType]
	{
		if self.isFolder == true { return [.rename, .move, .convert, .delete, .cancel] }
		else { return  [.reschedule, .move, .convert, .delete, .cancel]  }
	}
}
