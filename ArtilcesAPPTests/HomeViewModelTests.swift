//
//  HomeViewModelTests.swift
//  ArtilcesAPPTests
//
//  Created by Binil V on 09/03/22.
//

import XCTest
@testable import ArtilcesAPP

let mostViewedArticleJsonFileName = "MostviewdArticle"

class HomeViewModelTests: XCTestCase {
  
  var viewModel: HomeViewModel?
  var model: Welcome?
  
  func getModelData() -> Welcome? {
    return testItem(for: mostViewedArticleJsonFileName)
  }
  
  func setupViewModel(data: Welcome?, error: HandleError?) -> HomeViewModel? {
    let apiManager = ApiManagerMostViewedArticleListSpy()
    apiManager.addStub(dataModel: data, errorType: error)
    return HomeViewModel(with: apiManager)
  }
  
  
  override func setUpWithError() throws {
    try? super.setUpWithError()
    model = getModelData()
    viewModel = setupViewModel(data: model, error: nil)
    viewModel?.getMostViewedArticlesList()
  }
  
  override func tearDownWithError() throws {
    try? super.tearDownWithError()
    viewModel = nil
  }
  
  func testGroupData() throws {
    let section = viewModel?.groupData(data: model?.results)
    XCTAssertNotNil(section)
    XCTAssert((section?.count ?? -1) > 0, "Abence of section")
    let emptySection = viewModel?.groupData(data:nil)
    XCTAssertNil(emptySection)
    XCTAssert((emptySection?.count ?? -1) < 0, "Presence of section")
  }
  
  func testConfigureCell() throws {
    let data = viewModel?.configureCellData(data: model?.results?.first)
    XCTAssertNotNil(data?.0)
    XCTAssert("" != data?.1, "Image url not present to display image")
    let emptyData = viewModel?.configureCellData(data: nil)
    XCTAssertNil(emptyData?.0)
    XCTAssert("" == emptyData?.1, "Image url is present to display image")
  }
  
  func testFilter() throws {
    let section = viewModel?.filteredSections(for: "opinion")
    XCTAssertNotNil(section)
    XCTAssert((section?.count ?? -1) > 0 , "Abence of section")
    let emptySection = viewModel?.filteredSections(for: "EmptyData")
    XCTAssert((emptySection?.count ?? -1) <= 0 , "Presence of section")
  }
}
