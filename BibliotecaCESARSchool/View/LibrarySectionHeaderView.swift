//
//  LibrarySectionHeaderView.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 11/04/21.
//

import Foundation
import UIKit

class LibrarySectionHeaderView: UICollectionReusableView {
    // MARK: - Properties
    var label: UILabel!

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
    func setupViews() {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        addSubview(label)
        label.textAlignment = .center
        backgroundColor = .systemGray6
    }
}
