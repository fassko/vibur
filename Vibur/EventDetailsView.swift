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
    ScrollView {
      VStack(alignment: .leading, spacing: 15) {
        GroupBox("What was the experience?") {
          Text(event.experience)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("Were you aware of the \(event.pleasant ? "pleasant" : "unpleasant") feelings while the event was happening?") {
          Image(systemName: event.aware ? "checkmark.square" : "square")
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("How did your body feel, in detail, during this experience?") {
          Text(event.feelings)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("What moods and emotions were present?") {
          Text(event.moods)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("What thoughts were present?") {
          Text(event.thoughts)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("What thoughts are here as you write this down now?") {
          Text(event.thoughtsWriting)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        Spacer()
      }
      .padding()
    }
    .navigationTitle("\(event.timestamp, formatter: .itemFormatter)")
  }
}

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

struct EventDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      EventDetailsView(event: .mocked)
        .previewDevice("iPhone 13 Pro")
      
      EventDetailsView(event: .mocked)
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 13 Pro")
      
      EventDetailsView(event: .mocked)
        .previewDevice("iPad Pro (11-inch) (3rd generation)")
        .previewInterfaceOrientation(.landscapeLeft)
    }
  }
}
