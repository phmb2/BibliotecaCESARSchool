//
//  LoansViewController.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 13/04/21.
//

import UIKit
import Nuke

private let cellReuseIdentifier = "BookCell"

class LoansViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }
    
    // MARK: - Helpers
    func configureLayout() {
        let nib = UINib(nibName: cellReuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension LoansViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.shared.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! BookCell

        let order = User.shared.orders[indexPath.row]
        let imageUrl = order.book.thumbnailUrl
        let loanDate = order.loanDate
        
        if let url = imageUrl {
            Nuke.loadImage(with: url, into: cell.imageView)
        }
        
        cell.titleLabel.text = order.book.title
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        cell.dateLabel.text = "\(dateFormatterPrint.string(from: loanDate))"
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LoansViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 80, bottom: 8, right: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = view.frame.width
        let cellHeight: CGFloat = 160

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
