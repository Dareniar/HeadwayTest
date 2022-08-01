//
//  APIRequest.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import Foundation

/// Contains list of available API endpoints
enum APIRequest: Equatable {
  case signIn
  case searchRepos(query: String, page: Int)
  case codeExchange(code: String)
  
  // MARK: - Public Properties
  var requiresAuthorization: Bool {
    switch self {
    case .signIn, .codeExchange:
      return false
    default:
      return true
    }
  }
    
  // MARK: - Public Methods
  /// Converts _APIRequest_ to standard _URLRequest_
  /// - Parameter token: Bearer token to put in request header
  /// - Returns: _URLRequest_
  func toURLRequest(token: String? = nil) -> URLRequest? {
    guard let url = urlComponents(host: host, path: path, queryItems: parameters).url else {
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    if let token = token {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    return request
  }
}

extension APIRequest {
  private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
  }
  
  // MARK: - Private Properties
  private var httpMethod: HTTPMethod {
    switch self {
    case .codeExchange:
      return .post
    case .searchRepos, .signIn:
      return .get
    }
  }
  
  private var host: String {
    switch self {
    case .codeExchange, .signIn:
      return APIConfig.authHost
    default:
      return APIConfig.apiHost
    }
  }
  
  private var path: String {
    switch self {
    case .signIn:
      return "/login/oauth/authorize"
    case .codeExchange:
      return "/login/oauth/access_token"
    case .searchRepos:
      return "/search/repositories"
    }
  }
  
  private var parameters: [URLQueryItem] {
    let dictionary: [String: String?]
    var parameters = [URLQueryItem]()
    
    switch self {
    case .signIn:
      dictionary = ["client_id": APIConfig.clientID]
    case .codeExchange(code: let code):
      dictionary = [
        "client_id": APIConfig.clientID, "client_secret": APIConfig.clientSecret, "code": code
      ]
    case .searchRepos(query: let query, page: let page):
      dictionary = [
        "q": "\(query) in:name", "sort": "stars", "per_page": "15", "page": String(page)
      ]
    }
    
    for (key, value) in dictionary {
      parameters.append(URLQueryItem(name: key, value: value))
    }
    return parameters
  }
  
  // MARK: - Private Methods
  private func urlComponents(host: String, path: String, queryItems: [URLQueryItem]) -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = path
    urlComponents.queryItems = queryItems
    return urlComponents
  }
}
