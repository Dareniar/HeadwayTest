//
//  SearchLoader.swift
//  HeadwayTest
//
//  Created by Danil on 02.08.2022.
//

import Foundation
import Combine

protocol SearchLoadable {
  var totalCount: Int { get }
  func search(query: String, page: Int) -> AnyPublisher<[Repository], APIError>
}

final class SearchLoader: SearchLoadable {
  var totalCount = 0
  let api: APIFetchable
  
  init(api: APIFetchable) {
    self.api = api
  }
    
  func search(query: String, page: Int) -> AnyPublisher<[Repository], APIError> {
    if page == 1 {
      totalCount = 0
    }
    return api.fetch(request: .searchRepos(query: query, page: page))
      .map { [weak self] (response: SearchReposResponse) in
        self?.totalCount = response.totalCount
        return response.items.map { $0.toLocal() }
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}


