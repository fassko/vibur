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
  @State var showLoading = false
  @State private var item: ActivityItem?
  @State private var showEmptyListAlert = false
  
  @ObservedObject var eventsListViewModel: EventsListViewModel
  
  var body: some View {
    ZStack {
      addButton
      eventsList
      LoadingView(isShowing: $showLoading)
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
        Button(action: generateCSV) {
          Label("Export", systemImage: "square.and.arrow.up")
        }
        .activitySheet($item)
      }
    }
    .navigationTitle(title)
    .sheet(isPresented: $showAddEventView, onDismiss: eventsListViewModel.loadData)  {
      NewEventView(pleasant: eventsListViewModel.pleasant, context: context)
    }
    .alert(isPresented: $showEmptyListAlert) {
      Alert(title: Text("Vibur"), message: Text("There is nothing to export."))
    }
    .onAppear(perform: eventsListViewModel.loadData)
  }
}

private extension EventsListView {
  func generateCSV() {
    showLoadingView()
    
    guard !eventsListViewModel.events.isEmpty else {
      showEmptyListAlert = true
      showLoading = false
      return
    }
    
    eventsListViewModel.generateCSV { url in
      item = ActivityItem(
        items: url
      )
    }
    
    hideLoadingView()
  }
  
  func showLoadingView() {
    withAnimation {
      showLoading = true
    }
  }
  
  func hideLoadingView() {
    withAnimation {
      showLoading = false
    }
  }
  
  func deleteItems(offsets: IndexSet) {
    withAnimation {
      eventsListViewModel.deleteItems(offsets: offsets)
    }
  }
  
  private var pleasantUnpleasant: String {
    String(localized: eventsListViewModel.pleasant ? "Pleasant" : "Unpleasant")
  }
  
  private var title: LocalizedStringKey {
    LocalizedStringKey("\(pleasantUnpleasant) Events")
  }
  
  private var addButton: some View {
    Button("Add") {
      showAddEventView = true
    }
    .keyboardShortcut("n")
    .opacity(0)
  }
  
  private var emptyView: some View {
    VStack(spacing: 20) {
      Text("No events found right now")
        .font(.title2)
      
      Button("Add Event") {
        showAddEventView = true
      }
      LottieView(name: "empty-state", loopMode: .loop)
        .frame(width: 250, height: 250)
    }
  }
  
  private var eventsList: some View {
    ZStack {
      if eventsListViewModel.events.isEmpty {
        emptyView
      } else {
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
