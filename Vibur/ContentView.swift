//
//  ContentView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var context
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Event>
  
  var body: some View {
    if UIDevice.isIpad {
      navigationView
    } else {
      tabView
    }
  }
}

private extension ContentView {
  var navigationView: some View {
    NavigationView {
      List {
        NavigationLink(destination: EventsListView(eventsListViewModel: EventsListViewModel(pleasant: false, context: context))) {
          Label("Unpleasant Events", systemImage: "hand.thumbsdown.fill")
        }
        
        NavigationLink(destination: EventsListView(eventsListViewModel: EventsListViewModel(pleasant: true, context: context))) {
          Label("Pleasant Events", systemImage: "hand.thumbsup.fill")
        }
        
        NavigationLink(destination: AboutView()) {
          Label("About", systemImage: "info.circle")
        }
      }
      .listStyle(SidebarListStyle())
      .navigationTitle("Vibur")
      
      Text("Select what kind of events you would like to add.")
        .font(.title)
    }
  }
  
  var tabView: some View {
    TabView {
      NavigationView {
        EventsListView(eventsListViewModel: EventsListViewModel(pleasant: false, context: context))
      }
      .tabItem {
        Label("Unpleasant", systemImage: "hand.thumbsdown.fill")
      }
      
      NavigationView {
        EventsListView(eventsListViewModel: EventsListViewModel(pleasant: true, context: context))
      }
      .tabItem {
        Label("Pleasant", systemImage: "hand.thumbsup.fill")
      }
      
      AboutView()
        .tabItem {
          Label("About", systemImage: "info.circle")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
        .previewDevice("iPhone 13 Pro")
      
      ContentView()
        .previewDevice("iPad Pro (11-inch) (3rd generation)")
        .previewInterfaceOrientation(.landscapeRight)
    }
  }
}
