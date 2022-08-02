//
//  ContentView.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      SearchView(viewModel: searchViewModel)
        .tabItem {
          Label("Search", systemImage: "text.magnifyingglass")
        }
      HistoryView()
        .tabItem {
          Label("History", systemImage: "archivebox")
        }
    }
  }
}

private extension ContentView {
  private var searchViewModel: SearchViewModel {
    let api = APIFetcher()
    let auth = GithubOAuthorizator(api: api)
    let loader = SearchLoader(api: api)
    let cache = CacheHandler()
    return SearchViewModel(authorizator: auth, loader: loader, cache: cache)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
