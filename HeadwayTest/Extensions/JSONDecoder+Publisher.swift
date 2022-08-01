//
//  JSONDecoder+Publisher.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import Foundation
import Combine

extension JSONDecoder {
  func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, APIError> {
    if T.self == String.self, let string = String(data: data, encoding: .utf8) {
      return Just(string as! T)
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()
    } else {
      return Just(data)
        .decode(type: T.self, decoder: self)
        .mapError { .parsing(description: $0.localizedDescription) }
        .eraseToAnyPublisher()
    }
  }
}
