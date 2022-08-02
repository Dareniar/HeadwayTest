//
//  CacheHandler.swift
//  HeadwayTest
//
//  Created by Danil on 02.08.2022.
//

import SwiftUI
import RealmSwift

/// Defines behavior for working with Realm cache
protocol Cache {
  /// Indicates if repository was saved to cache
  /// - Parameter repository: Repository to check
  /// - Returns: _true_ if repository is saved to cache, otherwise _false_
  func isSaved(repository: Repository) -> Bool
  /// Save repository to Realm
  /// - Parameter repository: Repository to save
  func save(repository: Repository)
}

final class CacheHandler: Cache {
  @Environment(\.realm) var realm
  @ObservedResults(Repository.self) var repositories

  func save(repository: Repository) {
    guard repository.realm == nil, !isSaved(repository: repository) else {
      return
    }
    try? realm.write {
      if repositories.count == 20, let firstRepo = repositories.first {
        realm.delete(firstRepo)
      }
      realm.add(repository)
    }
  }
  
  func isSaved(repository: Repository) -> Bool {
    repositories.contains(where: { $0.urlString == repository.urlString })
  }
}
