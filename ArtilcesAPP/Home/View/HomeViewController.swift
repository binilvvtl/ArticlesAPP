//
//  HomeViewController.swift
//  ArtilcesAPP
//
//  Created by Binil V on 07/03/22.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Properties
  private var viewModel = HomeViewModel()
  private var sections = Section.allSections
  private lazy var dataSource = makeDataSource()
  private var searchController = UISearchController(searchResultsController: nil)
  private var child: SpinnerViewController?
  
  // MARK: - Value Types
  typealias DataSource = UICollectionViewDiffableDataSource<Section, ArticleResult>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ArticleResult>
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    collectionView.delegate = self
    setupUI()
  }
  
  // MARK: - Functions
  func setupUI() {
    configureSearchController()
    configureLayout()
    fetchArticles()
    applySnapshot(animatingDifferences: false)
  }
  
  // add the spinner view controller
  func createSpinnerView() {
    child = SpinnerViewController()
    guard let child = child else {
      return
    }
    addChild(child)
    child.view.frame = view.frame
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }

  // then remove the spinner view controller
  func destorySpinnerView() {
    DispatchQueue.main.async { [weak self] in
      guard let childSpinner = self?.child else {
        return
      }
      childSpinner.willMove(toParent: nil)
      childSpinner.view.removeFromSuperview()
      childSpinner.removeFromParent()
      self?.child = nil
    }
  }
  
  // show alert with please try agian later
  func showAlertSomethingWentWrong() {
    self.openAlert(title: "error".localized(),
                   message: "somethingWentWrongWithLater".localized(),
                   alertStyle: .alert,
                   actionTitles: ["Okay".localized(), "Cancel".localized()],
                   actionStyles: [.default, .cancel],
                   actions: [
                    {_ in
                      
                    },
                    {_ in
                      
                    }
                   ])
  }
  
  // show alert with please try agian later and refresh Api call
  func showAlertWithReloadApiCall() {
    self.openAlert(title: "Error",
                   message: "somethingWentWrong".localized(),
                   alertStyle: .alert,
                   actionTitles: ["Okay".localized()],
                   actionStyles: [.default, .cancel],
                   actions: [
                    {_ in
                      self.fetchArticles()
                    }
                   ])
  }
}

// MARK: - UICollectionViewDatasource Implementation

extension HomeViewController {
  func makeDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, article) ->
        UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier,
          for: indexPath) as? ArticleCollectionViewCell
        let articleData = self.viewModel.configureCellData(data: article)
        cell?.configure(title: articleData.0, image: articleData.1)
        return cell
      })
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader else {
        return nil
      }
      let section = self.dataSource.snapshot()
        .sectionIdentifiers[indexPath.section]
      let view = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
        for: indexPath) as? SectionHeaderReusableView
      view?.titleLabel.text = section.title
      return view
    }
    return dataSource
  }
  
  func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections(sections)
    sections.forEach { section in
      snapshot.appendItems(section.article, toSection: section)
    }
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
  // MARK: - Making API call to fetch Articles
  
  func fetchArticles() {
    createSpinnerView()
    viewModel.getMostViewedArticlesList()
  }
}

// MARK: - UICollectionViewDelegate Implementation

extension HomeViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
    guard let article = dataSource.itemIdentifier(for: indexPath) else {
      showAlertSomethingWentWrong()
      return
    }
    guard let articleLink = URL(string: article.url ?? "") else {
      showAlertSomethingWentWrong()
      return
    }
    let safariViewController = SFSafariViewController(url: articleLink)
    present(safariViewController, animated: true, completion: nil)
  }

}

// MARK: - Layout Handling
extension HomeViewController {
  private func configureLayout() {
    collectionView.register(UINib.init(nibName: ArticleCollectionViewCell.reuseIdentifier, bundle: nil),
                            forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseIdentifier)
    collectionView.register(SectionHeaderReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
    )
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 230 : 250)
      )
      let itemCount = isPhone ? 1 : 3
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      // Supplementary header view setup
      let headerFooterSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(20)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [sectionHeader]
      return section
    })
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { context in
      self.collectionView.collectionViewLayout.invalidateLayout()
    }, completion: nil)
  }
}

// MARK: - API Service Protocol Confirming Methods
extension HomeViewController: APIServiceCompletionProtocol {
  
  func didFinishFetchingResponse(results: [Section]?, error: Error?) {
    if error == nil {
      DispatchQueue.main.async { [weak self] in
        guard let sectionData = results else {
          self?.destorySpinnerView()
          self?.showAlertWithReloadApiCall()
          return
        }
        Section.allSections = sectionData
        self?.sections = Section.allSections
        self?.applySnapshot(animatingDifferences: false)
        self?.destorySpinnerView()
      }
    } else {
      DispatchQueue.main.async { [weak self] in
        self?.destorySpinnerView()
        self?.showAlertWithReloadApiCall()
      }
    }
  }
}


// MARK: - Searchbar implementation
extension HomeViewController {
  func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "searchArticle".localized()
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
}


// MARK: - UISearchResultsUpdating Delegate
extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    sections = viewModel.filteredSections(for: searchController.searchBar.text)
    applySnapshot(animatingDifferences: true)
  }
}

// MARK: - SFSafariViewControllerDelegate Implementation
extension HomeViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
