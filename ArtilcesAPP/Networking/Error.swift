//
//  Error.swift
//  ArtilcesAPP
//
//  Created by Binil V on 09/03/22.
//

import Foundation

enum HandleError: Error {
  case invalidData
  case requestFailed
  case jsonConversionFailure
  case jsonParsingFailure
  case responseUnsuccessful
  case invalidRequest
  case resourceTimedOut // = -1001 /// Defined by iOS
  case notConnectedToInternet // = -1009 /// Defined by iOS
  case badRequest // = 400
  case unauthorized // = 401
  case forbidden // = 403
  case resourceNotFound // = 404
  case accountAlreadyExists // = 409
  case serverError // = 500
  case badGateway // = 501
  case serverUnavailable // = 503
  case noResponse // = -1000
  case unknown // = 1000
  case resetPasswordSuccess // = 204
  case tokenExpired // = 400 (Invalid Token)
  case sessionExpired
  case appExit // = 666
  
  var localizedDescription: String {
    switch self {
    case .invalidData:
      return "Invalid Data".localized()
    case .requestFailed:
      return "Request Failed".localized()
    case .jsonConversionFailure:
      return "JSON Conversion Failure".localized()
    case .jsonParsingFailure:
      return "JSON Parsing Failure".localized()
    case .responseUnsuccessful:
      return "Response Unsuccessful".localized()
    case .invalidRequest:
      return "Invalid Request".localized()
    case .resourceTimedOut:
      return "Resource timed out".localized()
    case .notConnectedToInternet:
      return "Not connected to internet".localized()
    case .badRequest:
      return "Server Error (Code 400)".localized()
    case .unauthorized:
      return "Not authorized (Code 401)".localized()
    case .forbidden:
      return "Resource forbidden (Code 403)".localized()
    case .resourceNotFound:
      return "Resource not found (Code 404)".localized()
    case .accountAlreadyExists:
      return "Account_Already_Exists".localized()
    case .badGateway:
      return "Bad gateway (Code 501)".localized()
    case .serverUnavailable:
      return "Service unavailable (Code 503)".localized()
    case .serverError:
      return "Server Error (Code 500)".localized()
    case .resetPasswordSuccess:
      return "Reset_Password_Successful".localized()
    case .sessionExpired:
      return "sessionExpired".localized()
    case .appExit:
      return "app_exit".localized()
    default:
      return "Some error occurred. Please try again".localized()
    }
  }
  
  var errorCode: Int {
    switch self {
    case .badRequest:
      return 400
    case .serverError:
      return 500
    case .notConnectedToInternet:
      return -1_009
    case .resetPasswordSuccess:
      return 204
    case .accountAlreadyExists:
      return 409
    case .unauthorized:
      return 401
    case .appExit:
      return 666
    default:
      return 1_000
    }
  }
}
