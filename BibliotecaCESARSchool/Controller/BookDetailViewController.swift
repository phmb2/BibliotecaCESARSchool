//
//  BookDetailViewController.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 11/04/21.
//

import Foundation
import UIKit
import Nuke

class BookDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pagesCountLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var descriptionItemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var requestLoanButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var thumbnailBook: URL?
    var titleBook: String = ""
    var authorsBook: [String] = []
    var isbnBook: String? = ""
    var dateBook: Date?
    var numberPagesBook: Int = 0
    var categoriesBook: [String] = []
    var descriptionBook: String? = ""
    var quantityBook: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    // MARK: - Helpers
    func configureLayout() {
        
        if let url = thumbnailBook {
            Nuke.loadImage(with: url, into: imageView)
        }
        
        titleLabel.text = titleBook
        
        let authorsRepresentation = stringsFormatted(array: authorsBook)
        authorsLabel.text = authorsRepresentation
        
        if let isbnValue = isbnBook {
            isbnLabel.text = "ISBN: \(isbnValue)"
        }
        
        if let dateValue = dateBook {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"
            dateLabel.text = "Publicado em \(dateFormatterPrint.string(from: dateValue))"
        }
        
        pagesCountLabel.text = pagesCountLabelFormatted(pagesCount: numberPagesBook)
        
        let categoriesRepresentation = stringsFormatted(array: categoriesBook, text: "Categorias: ")
        categoriesLabel.text = categoriesRepresentation
        
        if descriptionBook == nil {
            descriptionItemLabel.isHidden = true
        }
        
        descriptionLabel.text = descriptionBook
        
        disableRequestLoanButton()
        quantityLabel.text = quantityLabelFormatted(quantity: quantityBook)
    }
    
    // MARK: - Actions
    func stringsFormatted(array: [String], text: String? = nil) -> String {
        if array.count > 0 {
            var value = array.joined(separator: ", ")
            
            if let categoriesText = text {
                value = categoriesText + " " + array.joined(separator: ", ")
            }
            
            return value
        } else {
            if let categoriesText = text {
                return categoriesText + "Outros"
            }
            return ""
        }
    }
    
    func pagesCountLabelFormatted(pagesCount: Int) -> String {
        if (pagesCount == 1) {
            return "\(pagesCount) página"
        } else {
            return "\(pagesCount) páginas"
        }
    }
    
    func quantityLabelFormatted(quantity: Int) -> String {
        if (quantity == 1) {
            return "\(quantity) exemplar disponível"
        } else {
            return "\(quantity) exemplares disponíveis"
        }
    }
    
    func disableRequestLoanButton(order: Order? = nil) {
        var bookRequested = false
        
        if let orderValue = order {
            bookRequested = User.shared.orders.contains { $0.book == orderValue.book }
        }
        
        if quantityBook == 0 || bookRequested {
            requestLoanButton.isEnabled = false
            requestLoanButton.backgroundColor = .gray
        }
    }
    
    func decrementBooks() -> Int {
        return quantityBook - 1
    }
    
    @IBAction func handleRequestLoanAction(_ sender: Any) {
        if quantityBook > 0 {
            quantityBook = decrementBooks()
            quantityLabel.text = quantityLabelFormatted(quantity: quantityBook)
            
            var order: Order
            
            let book = Book(title: titleBook, isbn: isbnBook, pageCount: numberPagesBook, thumbnailUrl: thumbnailBook, shortDescription: descriptionBook, longDescription: nil, authors: authorsBook, categories: categoriesBook, publishedDate: dateBook, quantity: quantityBook)
            
            order = Order(book: book, loanDate: Date())
            
            User.shared.orders.append(order)
            
            disableRequestLoanButton(order: order)
            
            let loansVC = self.storyboard?.instantiateViewController(withIdentifier: "loansViewController") as! LoansViewController
            
            self.tabBarController?.selectedIndex = 1
            self.tabBarController?.navigationController?.pushViewController(loansVC, animated: true)
        }
    }
}
