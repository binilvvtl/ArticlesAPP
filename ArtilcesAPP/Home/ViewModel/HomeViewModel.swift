//
//  HomeViewModel.swift
//  ArtilcesAPP
//
//  Created by Binil V on 06/03/22.
//

import Foundation

protocol APIServiceCompletionProtocol: NSObject {
  func didFinishFetchingResponse(results: [Section]?, error: Error?)
}

final class HomeViewModel: NSObject {
  
  // MARK: - Properties
  private var apiService: ApiManagerMostViewedArticleListProtocol?
  weak var delegate: APIServiceCompletionProtocol?

  init(with service: ApiManagerMostViewedArticleListProtocol = APIService()) {
    apiService = service
  }

  // api call to fetch article
  func getMostViewedArticlesList() {
    
    apiService?.getMostViewedArticles { [weak self] response in
      switch response {
      case .success(let data):
        let section = self?.groupData(data: data?.results)
        Section.allSections = section ?? []
        self?.delegate?.didFinishFetchingResponse(results: section, error: nil)
      case .failure(let error):
        self?.delegate?.didFinishFetchingResponse(results: nil, error: error)
      }
    }
  }
  
  // Group the data for view representation
  func groupData(data: [ArticleResult]?) -> [Section]?{
    var articleSection = [String:[ArticleResult]]()
    var section = [Section]()
    guard let dataUnwraped = data else {
      return nil
    }
    for article in dataUnwraped {
      var array = [ArticleResult]()
      if let articleArray = articleSection[article.section ?? ""] {
        array = articleArray
      }
      array.append(article)
      articleSection[article.section ?? ""] = array
    }
    for (key,value) in articleSection {
      section.append(Section(title: key, article: value))
    }
    return section
  }
  
  // Prepare the tuple for the cell to display
  func configureCellData(data: ArticleResult?) -> (String?, String) {
    guard let article = data else {
      return (nil,"")
    }
    return (article.title, article.media?.first?.mediaMetadata?[1].url ?? "")
  }
  
  // Filter the data based on serach string
  func filteredSections(for queryOrNil: String?) -> [Section] {
    let sections = Section.allSections
    guard let query = queryOrNil, !query.isEmpty else {
      return sections
    }
    return sections.filter { section in
      var matches = section.title.lowercased().contains(query.lowercased())
      for article in section.article {
        if (article.title ?? "").lowercased().contains(query.lowercased()) {
          matches = true
          break
        }
      }
      return matches
    }
  }
}

