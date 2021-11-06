//
//  CardGroupBoxStyle.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import SwiftUI

struct CardGroupBoxStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      configuration.label
        .font(.subheadline)
      
      HStack {
        configuration.content
          .font(.body)
        Spacer()
      }
    }
    .padding(10)
    .background(Color(uiColor: .secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
  }
}
