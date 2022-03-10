//
//  ApiManagerMostViewedArticleListSpy.swift
//  ArtilcesAPPTests
//
//  Created by Binil V on 09/03/22.
//

import Foundation

final class ApiManagerMostViewedArticleListSpy: ApiManagerMostViewedArticleListProtocol {
  
  var articleResponseModel: Welcome?
  var error: HandleError?
  
  func addStub(dataModel: Welcome?, errorType: HandleError?) {
    articleResponseModel = dataModel
    error = errorType
  }
  
  func getMostViewedArticles(completion : @escaping (Result<Welcome?, HandleError>) -> Void) {
    if let error = error {
      completion(Result.failure(error))
    } else {
      guard let responseModel = articleResponseModel else {
        completion(Result.failure(.unknown))
        return
      }
      completion(Result.success(responseModel))
    }
  }
}
