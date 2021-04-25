//
//  LibraryViewController.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 26/03/21.
//

import UIKit
import Nuke

private let sectionHeaderReuseIdentifier = "sectionHeaderReuseIdentifier"
private let cellReuseIdentifier = "BookCell"
private let bookDetailSegue = "bookDetailSegue"

class LibraryViewController: UIViewController {

    // MARK: - Properties
    let library = Library.shared
    let preheater = ImagePreheater()
    var anotherBooks: [Book] = []
    var books: [Book] = []
    var categories: [String] = []
    
    private var sections = [Section]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var filteredBooks = [Section]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    func configureLayout() {
        let nib = UINib(nibName: cellReuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(LibrarySectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        configureSearchController()
        configureSections()
    }
    
    func configureSections() {
        
        for book in library.books {
            if book.categories.count > 0 {
                categories = categories + book.categories
            }
        }
        
        categories = categories.removingDuplicates().sorted{ $0.localizedCompare($1) == .orderedAscending }
        
        for category in categories {
            for book in library.books {
                if book.categories.count > 0 {
                    if book.categories.contains(category) {
                        if category == "" {
                            anotherBooks.append(book)
                        } else {
                            books.append(book)
                        }
                    }
                } else {
                    anotherBooks.append(book)
                }
            }
            
            if (category != "") {
                sections.append(Section(category: category, books: books))
            }
            books = []
        }
        
        sections.append(Section(category: "Outros", books: anotherBooks))
        sections = sections.sorted { $0.category.localizedCompare($1.category) == .orderedAscending }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar Livros"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tabBarController?.tabBar.isHidden = true
        
        if segue.identifier == bookDetailSegue {
            let bookDetailVC = segue.destination as! BookDetailViewController
            let indexPath = sender as? IndexPath
            let book = inSearchMode ? filteredBooks[indexPath!.section].books[indexPath!.row] : sections[indexPath!.section].books[indexPath!.row]
            bookDetailVC.thumbnailBook = book.thumbnailUrl
            bookDetailVC.titleBook = book.title
            bookDetailVC.authorsBook = book.authors
            bookDetailVC.isbnBook = book.isbn
            bookDetailVC.dateBook = book.publishedDate
            bookDetailVC.numberPagesBook = book.pageCount
            bookDetailVC.categoriesBook = book.categories
            bookDetailVC.descriptionBook = book.shortDescription
            bookDetailVC.quantityBook = book.quantity
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LibraryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return inSearchMode ? filteredBooks.count : sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredBooks[section].books.count : sections[section].books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! BookCell
        
        let book = inSearchMode ? filteredBooks[indexPath.section].books[indexPath.row] : sections[indexPath.section].books[indexPath.row]
        
        if let url = book.thumbnailUrl {
            let request = ImageRequest(
                url: url,
                processors: cell.resizedImageProcessors)

            let options = ImageLoadingOptions(
                placeholder: UIImage(systemName: "book"),
                transition: .none
            )

            Nuke.loadImage(with: request, options: options, into: cell.imageView)
        }
        
        cell.titleLabel.text = book.title
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"
        if let dateValue = book.publishedDate {
            cell.dateLabel.text = "\(dateFormatterPrint.string(from: dateValue))"
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: bookDetailSegue, sender: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderReuseIdentifier, for: indexPath) as! LibrarySectionHeaderView
        let category = inSearchMode ? filteredBooks[indexPath.section].category : sections[indexPath.section].category
        headerView.label.text = category
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let columns: CGFloat = 3
        let verticalInset: CGFloat = 16
        let spacing: CGFloat = 10
        let availableWidth = screenWidth - (verticalInset * 2) - (spacing * (columns - 1))
        let cellWidth = floor(availableWidth / columns)
        let cellHeight: CGFloat = 160

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = 44
        return CGSize(width: view.frame.width, height: height)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension LibraryViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { indexPath in
            library.books[indexPath.row].thumbnailUrl
        }
        preheater.startPreheating(with: urls)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { indexPath in
            library.books[indexPath.row].thumbnailUrl
        }
        preheater.stopPreheating(with: urls)
    }
}

// MARK: - UISearchResultsUpdating
extension LibraryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredBooks = sections.filter { $0.books.filter { $0.title.localizedStandardContains(searchText) }.count != 0 }
    }
}

// MARK: - Element
extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
