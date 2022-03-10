//
//  ArtilcesAPPTests.swift
//  ArtilcesAPPTests
//
//  Created by Binil V on 06/03/22.
//

import XCTest
@testable import ArtilcesAPP

class ArtilcesAPPTests: XCTestCase {
  
  var viewModel: HomeViewModel?
  var model: Welcome?
  
  override func setUpWithError() throws {
    try? super.setUpWithError()
    model = testItem(for: mostViewedArticleJsonFileName)
  }
  
  override func tearDownWithError() throws {
    try? super.tearDownWithError()
    viewModel = nil
  }
  
}
