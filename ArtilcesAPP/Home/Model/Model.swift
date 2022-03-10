//
//  Model.swift
//  ArtilcesAPP
//
//  Created by Binil V on 06/03/22.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
  let status, copyright: String?
  let numResults: Int?
  let results: [ArticleResult]?
  
  enum CodingKeys: String, CodingKey {
    case status, copyright
    case numResults
    case results
  }
}

// MARK: - Result
struct ArticleResult: Codable, Hashable {
  let uri: String?
  let url: String?
  let id, assetID: Int?
  let source: Source?
  let publishedDate, updated, section: String?
  let subsection: String?
  let nytdsection, adxKeywords: String?
  let column: JSONNull?
  let byline: String?
  let type: String?
  let title, abstract: String?
  let desFacet, orgFacet, perFacet, geoFacet: [String]?
  let media: [Media]?
  let etaID: Int?
  
  enum CodingKeys: String, CodingKey {
    case uri, url, id
    case assetID
    case source
    case publishedDate
    case updated, section, subsection, nytdsection
    case adxKeywords
    case column, byline, type, title, abstract
    case desFacet
    case orgFacet
    case perFacet
    case geoFacet
    case media
    case etaID
  }
  
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: ArticleResult, rhs: ArticleResult) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: - Media
struct Media: Codable {
  let type: MediaType?
  let subtype: Subtype?
  let caption, copyright: String?
  let approvedForSyndication: Int?
  let mediaMetadata: [MediaMetadatum]?
  
  enum CodingKeys: String, CodingKey {
    case type, subtype, caption, copyright
    case approvedForSyndication
    case mediaMetadata = "media-metadata"
  }
}

// MARK: - MediaMetadatum
struct MediaMetadatum: Codable {
  let url: String?
  let format: Format?
  let height, width: Int?
}

enum Format: String, Codable {
  case mediumThreeByTwo210 = "mediumThreeByTwo210"
  case mediumThreeByTwo440 = "mediumThreeByTwo440"
  case standardThumbnail = "Standard Thumbnail"
}

enum Subtype: String, Codable {
  case photo = "photo"
}

enum MediaType: String, Codable {
  case image = "image"
}

enum Source: String, Codable {
  case newYorkTimes = "New York Times"
}

enum Subsection: String, Codable {
  case empty = ""
  case move = "Move"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
  
  public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
    return true
  }
  
  public var hashValue: Int {
    return 0
  }
  
  public init() {}
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}
