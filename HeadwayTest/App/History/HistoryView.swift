//
//  HistoryView.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI

struct HistoryView: View {
  let repos = Array(repeating: Repository.preview(), count: 100)
  
  var body: some View {
    NavigationView {
      List(repos) { repo in
        RepositoryRow(repository: repo)
      }
      .navigationTitle("History 📚")
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
  }
}

