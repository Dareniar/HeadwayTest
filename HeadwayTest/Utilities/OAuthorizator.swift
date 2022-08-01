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
  var isAuthorizedPublisher: Published<Bool>.Publisher { get }
  var authorizationErrorPublisher: Published<APIError?>.Publisher { get }
  func authorize()
}

final class GithubOAuthorizator: NSObject, ObservableObject, OAuthorizator {
  
  @Published private var isAuthorized: Bool
  var isAuthorizedPublisher: Published<Bool>.Publisher { $isAuthorized }
  
  @Published private var authError: APIError?
  var authorizationErrorPublisher: Published<APIError?>.Publisher { $authError }
  
  private let api: APIFetchable
  
  private var disposables = Set<AnyCancellable>()
  
  init(api: APIFetchable) {
    self.api = api
    self.authError = nil
    self.isAuthorized = KeychainSwift().getToken() != nil
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
  
  private func requestCodeExchange(code: String) {
    api.fetch(request: .codeExchange(code: code))
      .map(self.parseToken)
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
