//
//  SearchView.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI

struct SearchView: View {
  
  @State var text = ""
  let repos = Array(repeating: Repository.preview(), count: 100)
  
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
  }
}

private extension SearchView {
  var searchField: some View {
    TextField("Type here to search", text: $text)
  }
  
  var reposSection: some View {
    Section {
      ForEach(repos, content: RepositoryRow.init(repository:))
    }
  }
  
  var loginButton: some View {
    Button("Sign In") {
      
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
