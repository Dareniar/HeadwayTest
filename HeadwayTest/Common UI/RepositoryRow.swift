//
//  RepositoryRow.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI
import RealmSwift

struct RepositoryRow: View {
  @ObservedObject var viewModel: RepositoryRowViewModel
    
  init(repository: Repository, cache: Cache? = nil) {
    self.viewModel = RepositoryRowViewModel(repository: repository, cache: cache)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(viewModel.repository.name).font(.title3).bold()
      if let description = viewModel.repository.repoDescription {
        Text(description)
          .frame(maxHeight: 120)
      }
      Text(viewModel.repository.stars).fontWeight(.light)
    }
    .opacity(viewModel.isViewed ? 0.3 : 1)
    .padding(.vertical, 10)
    .onTapGesture {
      viewModel.rowTapped()
    }
    .onAppear {
      viewModel.onAppear()
    }
  }
}

struct RepositoryRow_Previews: PreviewProvider {
  static var previews: some View {
    RepositoryRow(repository: .preview())
  }
}
