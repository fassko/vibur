//
//  EventDetailsView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 25/10/2021.
//

import SwiftUI
import CoreData

struct EventDetailsView: View {
  let event: EventItem
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(event.experience)
      Image(systemName: event.aware ? "checkmark.square" : "square")
      
      Spacer()
    }
    .navigationTitle("\(event.timestamp, formatter: .itemFormatter)")
  }
}

struct EventDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    EventDetailsView(event: .mocked)
      .previewDevice("iPad Pro (11-inch) (3rd generation)")
      .previewInterfaceOrientation(.landscapeLeft)
  }
}
