//
//  APIError.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import Foundation

enum APIError: Error {
  case parsing(description: String)
  case network(description: String)
}
