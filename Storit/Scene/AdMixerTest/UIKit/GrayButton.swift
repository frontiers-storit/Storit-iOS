//
//  GrayButton.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/19/24.
//

import UIKit

class GrayButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(.black, for: .normal)
        self.setTitle("", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
