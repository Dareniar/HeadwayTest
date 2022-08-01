//
//  KeychainSwift+Bearer.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import KeychainSwift

extension KeychainSwift {
  func resetToken() {
    delete(bearer)
  }
  
  func getToken() -> String? {
    get(bearer)
  }
  
  func saveToken(_ value: String) {
    set(value, forKey: bearer)
  }
  
  private var bearer: String {
    "Bearer token"
  }
}
