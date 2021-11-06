//
//  LoadingView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 06/11/2021.
//

import SwiftUI

struct LoadingView: View {
  @Binding var isShowing: Bool
  
  var body: some View {
    VStack {
      ProgressView("Loading")
        .progressViewStyle(CircularProgressViewStyle())
        .font(.title)
    }
    .frame(width: 250, height: 150)
    .background(Color.secondary.colorInvert())
    .foregroundColor(Color.primary)
    .cornerRadius(20)
    .opacity(isShowing ? 1 : 0)
  }
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LoadingView(isShowing: .constant(true))
      
      LoadingView(isShowing: .constant(true))
        .preferredColorScheme(.dark)
    }
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
