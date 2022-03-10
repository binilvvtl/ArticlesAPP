//
//  XCTestCaseExtension.swift
//  ArtilcesAPPTests
//
//  Created by Binil V on 07/03/22.
//

@testable import ArtilcesAPP
import XCTest

extension XCTestCase {
  
  func testItem<T: Decodable>(for fileName: String) -> T? {
    try? testItemWithError(for: fileName)
  }
  
  enum ItemError: Error {
    case missingResource(named: String)
  }
  
  func testItemWithError<T: Decodable>(for fileName: String) throws -> T {
    guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
      throw ItemError.missingResource(named: fileName)
    }
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    return try JSONDecoder().decode(T.self, from: data)
  }
  
  func stubJSON(for fileName: String) -> [String: Any]? {
    guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json"),
          let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
    return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
  }
  
}
