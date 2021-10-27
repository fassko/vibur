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
  
  var title: String {
    "\(pleasant ? "Pleasant" : "Unpleasant") Events"
  }
  
  init(pleasant: Bool) {
    self.pleasant = pleasant
    
    _events = FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: true)],
      predicate: NSPredicate(format: "pleasant == %@", NSNumber(value: pleasant))
    )
  }
  
  var body: some View {
    ZStack {
      Button("Add") {
        showAddEventView = true
      }
      .keyboardShortcut("n")
      .opacity(0)
      
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
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
      }
      ToolbarItem {
        Button {
          showAddEventView = true
        } label: {
          Label("Add Event", systemImage: "plus")
        }
      }
    }
    .navigationTitle(title)
    .sheet(isPresented: $showAddEventView) {
      NewEventView(pleasant: pleasant, context: viewContext)
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
