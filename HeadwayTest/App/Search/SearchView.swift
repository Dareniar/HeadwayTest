//
//  SearchView.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI

struct SearchView: View  {
  @ObservedObject var viewModel: SearchViewModel
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationView {
      List {
        searchField
        reposSection
      }
      .navigationTitle("Search repos 👾")
      .toolbar {
        loginButton
      }
    }
    .navigationViewStyle(.stack)
    .alert(isPresented: $viewModel.showError) {
      errorAlert
    }
  }
}

private extension SearchView {
  var searchField: some View {
    TextField(
      viewModel.isAuthorized ? "Type here to search" : "Sign In to search",
      text: $viewModel.searchQuery
    )
    .disabled(!viewModel.isAuthorized)
  }
  
  var reposSection: some View {
    Section {
      ForEach(viewModel.repositories) { repository in
        RepositoryRow(repository: repository, cache: viewModel.cache)
          .onAppear {
            viewModel.searchMore(currentItem: repository)
          }
      }
    }
  }
  
  var loginButton: some View {
    Button(viewModel.isAuthorized ? "Sign Out" : "Sign In") {
      viewModel.authorize()
    }
  }
  
  var errorAlert: Alert {
    let error = viewModel.error ?? .network(description: "")
    return Alert(
      title: Text(error.alertTitle),
      message: Text(error.message),
      dismissButton: .cancel(Text("Ok"))
    )
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(viewModel: SearchViewModel(
      authorizator: GithubOAuthorizator(api: APIFetcher()),
      loader: SearchLoader(api: APIFetcher()),
      cache: CacheHandler()
    ))
  }
}
