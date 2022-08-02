//
//  Repository.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import Foundation

struct Repository: Identifiable {
  let id = UUID()
  let name: String
  let stars: String
  let description: String
  let url: URL?
  
  static func preview() -> Repository {
    Repository(
      name: "Headway",
      stars: "⭐️ 2.4k",
      description: "Bite-sized learning app that gives you key ideas",
      url: URL(string: "https://apps.get-headway.com")
    )
  }
}
