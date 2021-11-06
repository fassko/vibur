//
//  EventsListView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

struct EventsListView: View {
  @Environment(\.managedObjectContext) private var context
  
  @State private var showAddEventView = false
  
  @ObservedObject var eventsListViewModel: EventsListViewModel
  
  var body: some View {
    ZStack {
      addButton
      eventsList
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showAddEventView = true
        } label: {
          Label("Add Event", systemImage: "plus")
        }
      }
      
      ToolbarItem(placement: .navigationBarLeading) {
        Menu {
          Button {
            eventsListViewModel.ascending = false
          } label: {
            Label("Newest to Oldest", systemImage: "arrow.up")
          }
          
          Button {
            eventsListViewModel.ascending = true
          } label: {
            Label("Oldest to Newest", systemImage: "arrow.down")
          }
        } label: {
          Label("More", systemImage: "ellipsis.circle")
        }
      }
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          
        } label: {
          Label("Export", systemImage: "square.and.arrow.up")
        }
      }
    }
    .navigationTitle(title)
    .sheet(isPresented: $showAddEventView, onDismiss: eventsListViewModel.loadData)  {
      NewEventView(pleasant: eventsListViewModel.pleasant, context: context)
    }
    .onAppear(perform: eventsListViewModel.loadData)
  }
}

private extension EventsListView {
  func deleteItems(offsets: IndexSet) {
    withAnimation {
      eventsListViewModel.deleteItems(offsets: offsets)
    }
  }
  
  private var title: String {
    "\(eventsListViewModel.pleasant ? "Pleasant" : "Unpleasant") Events"
  }
  
  private var addButton: some View {
    Button("Add") {
      showAddEventView = true
    }
    .keyboardShortcut("n")
    .opacity(0)
  }
  
  private var eventsList: some View {
    List {
      ForEach(eventsListViewModel.events) { event in
        NavigationLink {
          EventDetailsView(eventDetailsViewModel: EventDetailsViewModel(event: event, context: context, storage: CoreDataStorage()))
        } label: {
          VStack(alignment: .leading, spacing: 10) {
            Text(event.timestamp!, formatter: .itemFormatter)
              .font(.subheadline)
            
            Text(event.experience ?? "")
              .lineLimit(3)
              .font(.body)
          }
          .padding(.vertical, 5)
        }
      }
      .onDelete(perform: deleteItems)
    }
  }
}

struct EventsListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EventsListView(eventsListViewModel: EventsListViewModel(pleasant: true, context: PersistenceController.preview.container.viewContext))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.landscapeLeft)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
