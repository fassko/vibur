//
//  ContentView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Event>
  
  private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom
  }
  
  var body: some View {
    if UIDevice.isIpad {
      NavigationView {
        List {
          NavigationLink(destination: EventsListView(pleasant: false)) {
            Label("Unpleasant Events", systemImage: "minus.square")
          }
          
          NavigationLink(destination: EventsListView(pleasant: true)) {
            Label("Pleasant Events", systemImage: "plus.square")
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
    } else {
      TabView {
        NavigationView {
          EventsListView(pleasant: false)
        }
        .tabItem {
          Label("Unpleasant", systemImage: "minus.square")
        }
        
        NavigationView {
          EventsListView(pleasant: true)
        }
        .tabItem {
          Label("Pleasant", systemImage: "plus.square")
        }
        
        AboutView()
          .tabItem {
            Label("About", systemImage: "info.circle")
          }
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
