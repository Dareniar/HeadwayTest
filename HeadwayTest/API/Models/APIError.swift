//
//  APIError.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import Foundation

enum APIError: Error {
  case parsing(description: String)
  case network(description: String)
  
  var alertTitle: String {
    switch self {
    case .network: return "Network Error"
    case .parsing: return "Parsing Error"
    }
  }
  
  var message: String {
    switch self {
    case .parsing(let description), .network(let description):
      return description
    }
  }
}
