//
//  RepositoryRow.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import SwiftUI

struct RepositoryRow: View {
  let repository: Repository
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(repository.name).font(.title3).bold()
      if let description = repository.description {
        Text(description)
      }
      Text(repository.stars).fontWeight(.light)
    }
    .padding(.vertical, 10)
    .onTapGesture {
      if let url = repository.url {
        UIApplication.shared.open(url)
      }
    }
  }
}

struct RepositoryRow_Previews: PreviewProvider {
  static var previews: some View {
    RepositoryRow(repository: .preview())
  }
}
