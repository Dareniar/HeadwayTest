//
//  SearchViewModel.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
  
  @Published private(set) var repositories = [Repository]()
  @Published var searchQuery = ""
  @Published var error: APIError?
  @Published var showError: Bool = false
  @Published var isAuthorized: Bool = false
  
  private let authorizator: OAuthorizator
  
  let cache: Cache
  
  private let loader: SearchLoadable
  private var isLoading = false
  
  private var currentPage = 1
  
  private var disposables = Set<AnyCancellable>()

  init(
    authorizator: OAuthorizator,
    loader: SearchLoadable,
    cache: Cache,
    scheduler: DispatchQueue = DispatchQueue(label: "SearchQueue")
  ) {
    self.authorizator = authorizator
    self.loader = loader
    self.cache = cache
    
    $searchQuery
      .dropFirst(1)
      .debounce(for: .seconds(0.5), scheduler: scheduler)
      .sink(receiveValue: { [weak self] _ in
        self?.searchRepositories()
      })
      .store(in: &disposables)
    
    authorizator.showErrorPublished.sink { [weak self] showError in
      self?.showError = showError
      self?.error = authorizator.authError
    }
    .store(in: &disposables)
    
    authorizator.isAuthorizedPublished.sink { [weak self] in
      self?.isAuthorized = $0
    }
    .store(in: &disposables)
  }
  
  func searchRepositories(withReset: Bool = true) {
    if withReset || searchQuery.isEmpty {
      currentPage = 1
      DispatchQueue.main.async { [weak self] in
        self?.repositories.removeAll()
      }
    }
    guard !searchQuery.isEmpty else {
      return
    }
    isLoading = true
    loader.search(query: searchQuery, page: currentPage)
      .zip(loader.search(query: searchQuery, page: currentPage + 1))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        switch value {
        case .failure(let error):
          self?.error = error
          self?.showError = true
        case .finished:
          break
        }
      } receiveValue: { [weak self] in
        var newRepos = $0.0
        newRepos.append(contentsOf: $0.1)
        self?.repositories.append(contentsOf: newRepos)
        self?.error = nil
        self?.showError = false
        self?.isLoading = false
      }
      .store(in: &disposables)
  }
  
  func searchMore(currentItem: Repository) {
    guard
      let index = repositories.firstIndex(where: { currentItem.id == $0.id }),
      index > repositories.count - 6,
      loader.totalCount > repositories.count,
      !isLoading
    else {
      return
    }
    currentPage += 2
    searchRepositories(withReset: false)
  }
  
  func authorize() {
    if isAuthorized {
      authorizator.deauthorize()
      searchQuery = ""
      searchRepositories()
    } else {
      authorizator.authorize()
    }
  }
}
