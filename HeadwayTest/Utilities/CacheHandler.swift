//
//  CacheHandler.swift
//  HeadwayTest
//
//  Created by Danil on 02.08.2022.
//

import SwiftUI
import RealmSwift

protocol Cache {
  func isSaved(repository: Repository) -> Bool 
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
      if repositories.count == 20, let lastRepo = repositories.last {
        realm.delete(lastRepo)
      }
      realm.add(repository)
    }
  }
  
  func isSaved(repository: Repository) -> Bool {
    repositories.contains(where: { $0.urlString == repository.urlString })
  }
}
