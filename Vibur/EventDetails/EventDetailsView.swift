//
//  EventDetailsView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 25/10/2021.
//

import SwiftUI
import CoreData
import Combine

struct EventDetailsView: View {
  @Environment(\.managedObjectContext) private var context
  
  @ObservedObject var eventDetailsViewModel: EventDetailsViewModel
  
  @State private var showEditEvent = false
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 15) {
        GroupBox("What was the experience?") {
          Text(eventDetailsViewModel.event.experience ?? "")
            .textSelection(.enabled)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("Were you aware of the \(eventDetailsViewModel.event.pleasant ? "pleasant" : "unpleasant") feelings while the event was happening?") {
          Image(systemName: eventDetailsViewModel.event.aware ? "checkmark.square" : "square")
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("How did your body feel, in detail, during this experience?") {
          Text(eventDetailsViewModel.event.feelings ?? "")
            .textSelection(.enabled)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("What moods and emotions were present?") {
          Text(eventDetailsViewModel.event.moods ?? "")
            .textSelection(.enabled)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("What thoughts were present?") {
          Text(eventDetailsViewModel.event.thoughts ?? "")
            .textSelection(.enabled)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        GroupBox("What thoughts are here as you write this down now?") {
          Text(eventDetailsViewModel.event.thoughtsWriting ?? "")
            .textSelection(.enabled)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        
        Spacer()
      }
      .padding()
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Edit") {
          showEditEvent = true
        }
      }
    }
    .navigationTitle("\(eventDetailsViewModel.event.timestamp!, formatter: .itemFormatter)")
    .sheet(isPresented: $showEditEvent) {
      NewEventView(pleasant: eventDetailsViewModel.event.pleasant, context: context, event: eventDetailsViewModel.event)
    }
  }
}

//struct EventDetailsView_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//      EventDetailsView(, event: .mocked)
//        .previewDevice("iPhone 13 Pro")
//
//      EventDetailsView(event: .mocked)
//        .preferredColorScheme(.dark)
//        .previewDevice("iPhone 13 Pro")
//
//      EventDetailsView(event: .mocked)
//        .previewDevice("iPad Pro (11-inch) (3rd generation)")
//        .previewInterfaceOrientation(.landscapeLeft)
//    }
//  }
//}
