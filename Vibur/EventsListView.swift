//
//  EventsListView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

struct EventsListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest private var events: FetchedResults<Event>
  
  @State private var showAddEventView = false
  
  let pleasant: Bool
  
  init(pleasant: Bool) {
    self.pleasant = pleasant
    
    _events = Event.pleasantFetchRequest(pleasant: pleasant)
  }
  
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
        Button {
          
        } label: {
          Label("Export", systemImage: "square.and.arrow.up")
        }
      }
    }
    .navigationTitle(title)
    .sheet(isPresented: $showAddEventView) {
      NewEventView(pleasant: pleasant, context: viewContext)
    }
  }
}

private extension EventsListView {
  private var title: String {
    "\(pleasant ? "Pleasant" : "Unpleasant") Events"
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
      ForEach(events) { event in
        NavigationLink {
          EventDetailsView(event: .init(event: event))
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
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { events[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

struct EventsListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EventsListView(pleasant: true)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.landscapeLeft)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
