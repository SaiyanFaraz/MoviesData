//
//  RatingControl.swift
//  MovieDatabase
//
//  Created by Shabuddin SA on 14/10/24.
//

import Foundation
import UIKit

class RatingPopupView: UIView {
    private let ratingsTextView = UITextView()
    private let closeButton = UIButton(type: .system)

    init(ratings: [Movie.Rating]) {
        super.init(frame: .zero)
        setupUI(ratings: ratings)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(ratings: [Movie.Rating]) {
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        // Prepare ratings text
        var ratingsText = ""
        for rating in ratings {
            ratingsText += "\(rating.source): \(rating.value)\n"
        }

        ratingsTextView.text = ratingsText
        ratingsTextView.isEditable = false
        ratingsTextView.textAlignment = .center
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)

        addSubview(ratingsTextView)
        addSubview(closeButton)
        
        ratingsTextView.setAnchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        closeButton.setAnchor(top: ratingsTextView.bottomAnchor, bottom: bottomAnchor,  paddingTop: 16, paddingBottom: 20)
        closeButton.centerX(inview: self)

    }
    
    @objc private func closePopup() {
        self.removeFromSuperview()
    }
}
