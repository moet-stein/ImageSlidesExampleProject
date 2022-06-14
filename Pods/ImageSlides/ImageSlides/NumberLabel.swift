//
//  NumberLabel.swift
//  ImageSlidesView
//
//  Created by Moe Steinmueller on 13.06.22.
//

import UIKit

public class NumberLabel: UILabel {
    var bgColor: CGColor
    var colorForText: UIColor
    
    init(bgColor: CGColor, colorForText: UIColor, frame: CGRect = .zero) {
        self.bgColor = bgColor
        self.colorForText = colorForText
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = colorForText
        layer.backgroundColor = bgColor
        layer.cornerRadius = 5
        textAlignment = .center
        font.withSize(12)
    }

}
