//
//  EventsListView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData
import Combine


class EventsListViewModel: ObservableObject {
  @Published var events = [Event]()
  
  let pleasant: Bool
  
  private var anyCancellables = Set<AnyCancellable>()
  
  private let context: NSManagedObjectContext
  
  var ascending = false {
    didSet {
      loadData()
    }
  }
  
  init(pleasant: Bool, context: NSManagedObjectContext) {
    self.context = context
    self.pleasant = pleasant
    
    loadData()
  }
  
  func loadData() {
    let request = Event.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Event.timestamp, ascending: ascending)]
    request.predicate = NSPredicate(format: "pleasant == %@", NSNumber(value: pleasant))
    
    do {
      events = try context.fetch(request)
    } catch {
      print("Failed to fetch")
    }
  }
  
  func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map {
        events[$0]
      }.forEach(context.delete)
      
      do {
        try context.save()
        loadData()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

struct EventsListView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
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
      NewEventView(pleasant: eventsListViewModel.pleasant, context: viewContext)
    }
    .onAppear(perform: eventsListViewModel.loadData)
  }
}

private extension EventsListView {
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
      .onDelete(perform: eventsListViewModel.deleteItems)
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
