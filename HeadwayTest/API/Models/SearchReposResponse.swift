//
//  SearchReposResponse.swift
//  HeadwayTest
//
//  Created by Danil on 02.08.2022.
//

import Foundation

struct SearchReposResponse: Decodable {
  let totalCount: Int
  let items: [RepositoryResponse]
  
  private enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case items
  }
}

struct RepositoryResponse: Decodable {
  let name: String
  let description: String
  let urlString: String
  let starsCount: Int
  
  private enum CodingKeys: String, CodingKey {
    case name = "full_name"
    case urlString = "html_url"
    case starsCount = "stargazers_count"
    case description
  }
  
  func toLocal() -> Repository {
    .init(name: name, stars: "⭐️ \(starsCount)", description: description, url: URL(string: urlString))
  }
}
