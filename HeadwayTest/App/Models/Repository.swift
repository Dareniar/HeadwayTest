//
//  Repository.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import RealmSwift
import Foundation

final class Repository: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var name = ""
  @Persisted var stars = ""
  @Persisted var repoDescription: String? = nil
  @Persisted var urlString = ""
  
  var url: URL? {
    URL(string: urlString)
  }
  
  static func preview() -> Repository {
    let repository = Repository()
    repository.name = "Headway"
    repository.stars = "⭐️ 2.4k"
    repository.repoDescription = "Bite-sized learning app that gives you key ideas"
    repository.urlString = "https://apps.get-headway.com"
    return repository
  }
}
