//
//  Section.swift
//  ArtilcesAPP
//
//  Created by Binil V on 07/03/22.
//

import Foundation

class Section: Hashable {
  var id = UUID()
  var title: String
  var article: [ArticleResult]
  
  init(title: String, article: [ArticleResult]) {
    self.title = title
    self.article = article
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Section, rhs: Section) -> Bool {
    lhs.id == rhs.id
  }
}

extension Section {
  static var allSections: [Section] = []
}
