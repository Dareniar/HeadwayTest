//
//  SearchLoader.swift
//  HeadwayTest
//
//  Created by Danil on 02.08.2022.
//

import Foundation
import Combine

protocol SearchLoadable {
  func search(query: String, page: Int) -> AnyPublisher<[Repository], APIError>
}

final class SearchLoader: SearchLoadable {
  let api: APIFetchable
  
  init(api: APIFetchable) {
    self.api = api
  }
    
  func search(query: String, page: Int) -> AnyPublisher<[Repository], APIError> {
    api.fetch(request: .searchRepos(query: query, page: page))
      .map { (response: SearchReposResponse) in
        response.items.map { $0.toLocal() }
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}


