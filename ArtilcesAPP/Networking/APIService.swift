//
//  APIService.swift
//  ArtilcesAPP
//
//  Created by Binil V on 06/03/22.
//

import Foundation

protocol ApiManagerMostViewedArticleListProtocol: AnyObject {
  func getMostViewedArticles(completion : @escaping (Result<Welcome?, HandleError>) -> Void)
}

final class APIService: ApiManagerMostViewedArticleListProtocol {
  
  // MARK: - GET API call using URLSession to fetch most viewed article
  
  func getMostViewedArticles(completion : @escaping (Result<Welcome?, HandleError>) -> Void) {
    if let url = URL.init(string: String(format: sourceURLType.mostViewedArticleList, apiKey) )  {
      URLSession.shared.dataTask(with: url) {data, urlResponse, error in
        guard let data = data else {
          completion(Result.failure(.invalidData))
          return
        }
        do {
          let articleList = try JSONDecoder().decode(Welcome.self, from: data)
          completion(Result.success(articleList))
        } catch {
          completion(.failure(.jsonParsingFailure))
        }
      }.resume()
    }
  }
}
