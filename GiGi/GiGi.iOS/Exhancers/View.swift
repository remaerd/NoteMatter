//
//  View.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 13/11/2017.
//

import UIKit

extension UIView
{
	func setCornerRadius(corners: UIRectCorner, radius: CGFloat)
	{
		let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskPath.cgPath
		self.layer.mask = maskLayer
	}
}
