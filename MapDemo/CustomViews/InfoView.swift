//
//  InfoView.swift
//  MapAndScrollViewTest
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class InfoView: UIView {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	func setup() {
		Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
		addSubview(baseView)
		self.backgroundColor = .white
		baseView.frame = self.bounds
		self.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false

		baseView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
       	baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
       	baseView.backgroundColor = .clear
       	
		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

		iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 11).isActive = true
		iconImageView.widthAnchor.constraint(equalToConstant: 66).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 66).isActive = true
		iconImageView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true

		titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 11).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -11).isActive = true
		titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 6).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -9).isActive = true

		backgroundImageView.image = UIImage.init(named: "cell_bg_top")
	}

	// MARK: Functions
}
