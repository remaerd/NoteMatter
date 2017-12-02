//
//  SoundManager.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 1/12/2017.
//

import Foundation
import AVFoundation

var cachedSounds = [String:SystemSoundID]()

enum Sound
{
	case alert
	case tapCell
	case tapLight
	case tapNavButton
	case slideStarted
	case slideSelected
	case slideCancel
	case checkboxSelect
	case checkboxDeselect
	case modalUp
	case modalDown
	case switchOn
	case switchOff
	
	var fileName: String
	{
		switch self
		{
		case .alert: return "alert"
		case .tapCell: return "tap-cell"
		case .tapLight: return "tap-light"
		case .tapNavButton: return "tap-nav"
		case .slideStarted: return "slide-start"
		case .slideSelected: return "slide-select"
		case .slideCancel: return "slide-cancel"
		case .checkboxSelect: return "checkbox-select"
		case .checkboxDeselect: return "checkbox-deselect"
		case .modalUp: return "modal-up"
		case .modalDown: return "modal-down"
		case .switchOn: return "switch-on"
		case .switchOff: return "switch-off"
		}
	}
	
	func play()
	{
		if Defaults.soundEffect.bool
		{
			let soundID: SystemSoundID
			if let id = cachedSounds[self.fileName] { soundID = id }
			else
			{
				var id = SystemSoundID()
				let url = Bundle.main.url(forResource: self.fileName, withExtension: "caf")!
				AudioServicesCreateSystemSoundID(url as CFURL, &id)
				soundID = id
			}
			AudioServicesPlaySystemSound(soundID)
		}
	}
}
