//
//  ViburTextEditor.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 04/11/2021.
//

import SwiftUI

struct ViburTextEditor: View {
  @Binding var text: String
  @FocusState var focusedField: Field?
  let field: Field
  
  var body: some View {
    TextEditor(text: $text)
      .frame(minHeight: 40)
      .padding(.horizontal, 5)
      .padding(.vertical, 3)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(.tertiary, lineWidth: 1)
      )
      .focused($focusedField, equals: field)
  }
}

struct ViburTextEditor_Previews: PreviewProvider {
  static var previews: some View {
    ViburTextEditor(text: .constant(""), field: .experience)
  }
}
