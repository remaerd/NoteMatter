//
//  Template.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 14/11/2017.
//
//

import Foundation
import CoreData

@objc(Template)
public class Template: NSManagedObject, Model
{
	public enum ActionType
	{
		case reschedule
		case rename
		case delete
		case move
		case more
		case cancel
		case lock
		case unlock
		case convertToFolder
		case convertToDocument
		case convertToTemplate
		case publishToPlatform
		case publishToWordpress
		case publishToMedium
		case exportAsMarkdown
		case exportAsRTF
		case exportAsPDF
		case exportAsDocX
		
		public var icon: String?
		{
			switch self
			{
			case .reschedule: return "0110-bell"
			case .rename: return "0601-pencil"
			case .delete: return "0109-delete"
			case .move: return "0220-move"
			case .more: return "0406-more"
			case .lock: return "0112-lock"
			case .unlock: return "0113-unlock"
			case .convertToFolder: return "0209-upload"
			case .convertToDocument: return "0209-upload"
			case .convertToTemplate: return "0615-copy"
			case .publishToWordpress: return "0209-upload"
			case .publishToPlatform: return "0209-upload"
			case .publishToMedium: return "0209-upload"
			case .exportAsMarkdown: return "0711-markdown"
			case .exportAsRTF: return "0711-markdown"
			case .exportAsPDF: return "0711-pdf"
			case .exportAsDocX: return "0711-markdown"
			case .cancel: return nil
			}
		}
		
		public var title: String
		{
			switch self
			{
			case .reschedule: return ".list.actions.reschedule".localized
			case .rename: return ".list.actions.rename".localized
			case .delete: return ".list.actions.delete".localized
			case .move: return ".list.actions.move".localized
			case .more: return ".list.actions.more".localized
			case .lock: return ".list.actions.lock".localized
			case .unlock: return ".list.actions.unlock".localized
			case .convertToFolder: return ".list.actions.convert.folder".localized
			case .convertToDocument: return ".list.actions.convert.document".localized
			case .convertToTemplate: return ".list.actions.convert.template".localized
			case .publishToPlatform: return ".list.actions.publish.platform".localized
			case .publishToWordpress: return ".list.actions.publish.wordpress".localized
			case .publishToMedium: return ".list.actions.publish.medium".localized
			case .exportAsMarkdown: return ".list.actions.export.markdown".localized
			case .exportAsRTF: return ".list.actions.export.rtf".localized
			case .exportAsPDF: return ".list.actions.export.pdf".localized
			case .exportAsDocX: return ".list.actions.export.docx".localized
			case .cancel: return ".universal.cancel".localized
			}
		}
	}
	
	public static var database: Database { return Database.standard }
	
	public static let internalTemplates : [Template.InternalTemplate] = [.document, .folder]
	
	public enum InternalTemplate
	{
		case folder
		case document
		case problem
		case diary
		case habit
		
		public var title: String
		{
			switch self
			{
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
			case .document: return "0715-document"
			case .folder: return "0819-folder"
			case .diary: return "0703-bookclosed"
			case .problem: return "0312-report"
			case .habit: return "1304-tulip"
			}
		}
	}
	
	public override func awakeFromInsert()
	{
		super.awakeFromInsert()
		let templates = try! Template.find(nil, sortDescriptors: [NSSortDescriptor(key: "index", ascending: false)], properties: ["index"], limit: 1)
		if templates.count == 0 { self.index = 0 } else { index = templates[0].index + Int32(arc4random_uniform(10000)) }
	}
	
	public var actions: [ActionType]
	{
		if self.isFolder == true { return [.rename, .move, .delete, .more, .cancel] }
		else { return  [.reschedule, .move, .delete, .more, .cancel]  }
	}
}
