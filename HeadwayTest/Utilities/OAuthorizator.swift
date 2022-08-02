//
//  OAuthorizator.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI
import AuthenticationServices
import KeychainSwift
import Combine

/// Defines basic behavior for OAuth
protocol OAuthorizator {
  /// Publisher for authorization state
  var isAuthorizedPublished: Published<Bool>.Publisher { get }
  /// Publisher for checking if error alert should be displayed
  var showErrorPublished: Published<Bool>.Publisher { get }
  /// Error received during authorization
  var authError: APIError? { get }
  
  /// Authorize using OAuth
  func authorize()
  /// Sign out from authorized app
  func deauthorize()
}

final class GithubOAuthorizator: NSObject, OAuthorizator, ObservableObject {
  
  @Published var isAuthorized: Bool
  var isAuthorizedPublished: Published<Bool>.Publisher { $isAuthorized }
  
  private(set) var authError: APIError? {
    didSet {
      showError = authError != nil
    }
  }
  
  var showErrorPublished: Published<Bool>.Publisher { $showError }
  @Published private var showError: Bool
  
  private let api: APIFetchable
  
  private var disposables = Set<AnyCancellable>()
  
  init(api: APIFetchable) {
    self.api = api
    self.authError = nil
    self.isAuthorized = KeychainSwift().getToken() != nil
    self.showError = false
    super.init()
  }

  func authorize() {
    guard let signInURL = APIRequest.signIn.toURLRequest()?.url else { return }
    
    let session = ASWebAuthenticationSession(
      url: signInURL, callbackURLScheme: APIConfig.callbackURLScheme
    ) { [weak self] callbackURL, error in
      guard
        error == nil,
        let callbackURL = callbackURL,
        let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
        let code = queryItems.first(where: { $0.name == "code" })?.value
      else {
        if let error = error {
          self?.authError = APIError.network(description: error.localizedDescription)
        }
        return
      }
      
      self?.requestCodeExchange(code: code)
    }
    
    session.presentationContextProvider = self
    session.prefersEphemeralWebBrowserSession = true
    
    if !session.start() {
      print("Failed to start ASWebAuthenticationSession")
    }
  }
  
  func deauthorize() {
    KeychainSwift().resetToken()
    isAuthorized = false
  }
  
  private func requestCodeExchange(code: String) {
    api.fetch(request: .codeExchange(code: code))
      .map(self.parseToken)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] value in
        switch value {
        case .failure(let error):
          self?.authError = error
        case .finished:
          break
        }
      } receiveValue: { [weak self] text in
        self?.authError = nil
        if let token = text {
          KeychainSwift().saveToken(token)
          print(token)
          self?.isAuthorized = true
        }
      }
      .store(in: &disposables)
  }
  
  private func parseToken(from text: String) -> String? {
    let components = text.components(separatedBy: "&")
    var dictionary: [String: String] = [:]
    for component in components {
      let itemComponents = component.components(separatedBy: "=")
      if let key = itemComponents.first, let value = itemComponents.last {
        dictionary[key] = value
      }
    }
    return dictionary["access_token"]
  }
}

extension GithubOAuthorizator: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    UIApplication.shared.mainWindow ?? ASPresentationAnchor()
  }
}
