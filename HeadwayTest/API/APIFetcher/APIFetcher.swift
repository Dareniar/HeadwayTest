//
//  APIFetcher.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import Foundation
import Combine
import KeychainSwift

protocol APIFetchable {
  /// Perform network request
  /// - Parameter url: URL request which contains information of needed headers and parameters
  /// - Returns: Publisher of API error or response with expected type
  func fetch<T: Decodable>(request: APIRequest) -> AnyPublisher<T, APIError>
}

final class APIFetcher: APIFetchable {
  
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func fetch<T>(request: APIRequest) -> AnyPublisher<T, APIError> where T : Decodable {
    let token = request.requiresAuthorization ? KeychainSwift().getToken() : nil
    guard let request = request.toURLRequest(token: token) else {
      let error = APIError.network(description: "Couldn't create URL Request")
      return Fail(error: error).eraseToAnyPublisher()
    }
    
    return session.dataTaskPublisher(for: request)
      .mapError { .network(description: $0.localizedDescription) }
      .flatMap { JSONDecoder().decode($0.data) }
      .eraseToAnyPublisher()
  }
}
