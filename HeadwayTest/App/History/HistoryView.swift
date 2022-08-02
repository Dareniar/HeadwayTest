//
//  HistoryView.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI
import RealmSwift

struct HistoryView: View {
  @ObservedResults(Repository.self) var repositories

  var body: some View {
    NavigationView {
      List(repositories.reversed()) { repo in
        RepositoryRow(repository: repo)
      }
      .navigationTitle("History 📚")
    }
    .navigationViewStyle(.stack)
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
  }
}

