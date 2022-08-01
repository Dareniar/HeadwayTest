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
      SearchView()
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
