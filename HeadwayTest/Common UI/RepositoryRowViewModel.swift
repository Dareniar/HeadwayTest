//
//  RepositoryRowViewModel.swift
//  HeadwayTest
//
//  Created by Danil on 02.08.2022.
//

import SwiftUI

final class RepositoryRowViewModel: ObservableObject {
  let repository: Repository
  let cache: Cache?
  
  @Published var isViewed: Bool = false
  
  init(repository: Repository, cache: Cache? = nil) {
    self.repository = repository
    self.cache = cache
  }
  
  func rowTapped() {
    if let url = repository.url {
      UIApplication.shared.open(url)
    }
    if let cache = cache {
      isViewed = true
      cache.save(repository: repository)
    }
  }
  
  func onAppear() {
    self.isViewed = cache?.isSaved(repository: repository) ?? false
  }
}
