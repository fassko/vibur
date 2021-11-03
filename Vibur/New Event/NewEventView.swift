//
//  NewEventView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 13/10/2021.
//

import SwiftUI
import CoreData

struct NewEventView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) private var viewContext
  
  @ObservedObject private var viewModel: NewEventViewModel
  
  private enum Field: Int, Hashable {
    case experience
    case feelings
    case moods
    case thoughts
    case thoughtsWriting
  }
  
  @FocusState private var focusedField: Field?
  
  init(pleasant: Bool, context: NSManagedObjectContext) {
    viewModel = NewEventViewModel(pleasant: pleasant, context: context)
  }
  
  private let textFieldSpacing: CGFloat = 7
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What was the experience?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .experience
              }
                        
            TextField("", text: $viewModel.experience)
              .textFieldStyle(RoundedTextFieldStyle())
              .focused($focusedField, equals: .experience)
          }
          
          Toggle(isOn: $viewModel.aware) {
            Text("Were you aware of the \(viewModel.pleasant ? "pleasant" : "unpleasant") feelings while the event was happening?")
              .font(.subheadline)
          }
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("How did your body feel, in detail, during this experience?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .feelings
              }
            
            TextField("", text: $viewModel.feelings)
              .textFieldStyle(RoundedTextFieldStyle())
              .focused($focusedField, equals: .feelings)
          }

          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What moods and emotions were present?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .moods
              }
            
            TextField("", text: $viewModel.moods)
              .textFieldStyle(RoundedTextFieldStyle())
              .focused($focusedField, equals: .moods)
          }
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What thoughts were present?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .thoughts
              }
            
            TextField("", text: $viewModel.thoughts)
              .textFieldStyle(RoundedTextFieldStyle())
              .focused($focusedField, equals: .thoughts)
          }
          
          VStack(alignment: .leading, spacing: textFieldSpacing) {
            Text("What thoughts are here as you write this down now?")
              .font(.subheadline)
              .onTapGesture {
                focusedField = .thoughtsWriting
              }
            
            TextField("", text: $viewModel.thoughtsWriting)
              .textFieldStyle(RoundedTextFieldStyle())
              .focused($focusedField, equals: .thoughtsWriting)
          }
          
          Button(action: save) {
            HStack {
              Spacer()
              Text("Save")
              Spacer()
            }
          }
          .keyboardShortcut(.defaultAction)
          .disabled(viewModel.saveButtonDisabled)
          .buttonStyle(.borderedProminent)
          .controlSize(.large)
        }
        .padding()
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          focusedField = .experience
        }
      }
      .navigationTitle("New \(viewModel.pleasant ? "Pleasant" : "Unpleasant") Event")
      .toolbar {
        ToolbarItem {
          Button(action: closeWindow) {
            Label("Cancel", systemImage: "xmark")
          }
        }
      }
    }
  }
  
  private func save() {
    withAnimation {
      viewModel.save {
        closeWindow()
      }
    }
  }
  
  private func closeWindow() {
    presentationMode.wrappedValue.dismiss()
  }
}


struct RoundedTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(10)
      .background(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .stroke(.tertiary, lineWidth: 1)
      )
  }
}

struct NewEventView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NewEventView(pleasant: true, context: PersistenceController.shared.container.viewContext)
        .previewDevice("iPhone 13 Pro")
        .navigationViewStyle(StackNavigationViewStyle())
      
      NewEventView(pleasant: true, context: PersistenceController.shared.container.viewContext)
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 13 Pro")
        .navigationViewStyle(StackNavigationViewStyle())
      
      NewEventView(pleasant: true, context: PersistenceController.shared.container.viewContext)
        .previewDevice("iPad Pro (11-inch) (3rd generation)")
        .navigationViewStyle(StackNavigationViewStyle())
.previewInterfaceOrientation(.landscapeLeft)
    }
  }
}
