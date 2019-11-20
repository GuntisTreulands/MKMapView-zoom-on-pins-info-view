//
//  PassThroughScrollView.swift
//  MapDemo
//
//  Created by Guntis on 01/09/2019.
//

import UIKit

class PassThroughScrollView: UIScrollView {

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return subviews.contains(where: {
			!$0.isHidden
			&& $0.isUserInteractionEnabled
			&& $0.point(inside: self.convert(point, to: $0), with: event)
		})
	}
}
