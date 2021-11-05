//
//  AboutView.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 02/11/2021.
//

import SwiftUI

struct AboutView: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Vibur")
        .font(.largeTitle)
      
      Image("vibur-logo")
        .resizable()
        .scaledToFit()
        .frame(width: logoWidth)
        .padding()
      
      Text("Unpleasant Events Calendar")
        .font(.title2)
      
      Text("Be aware of an unpleasant event at the time it is happening. Use these questions to focus your awareness on the details of the experience as it is happening. Write it down later.\n\nTry to record at least one unpleasant event each day.")
        .multilineTextAlignment(.center)
      
      Text("This application is developed and maintained by [Kristaps Grinbergs](https://kristaps.me/)")
        .multilineTextAlignment(.center)
      
      Spacer()
    }
    .padding()
    .padding(.horizontal)
  }
  
  private var logoWidth: CGFloat {
    let idiom = UIDevice.current.userInterfaceIdiom
    let isPortrait = UIDevice.current.orientation.isPortrait
    
    let constant: CGFloat = {
      if idiom == .pad {
        if isPortrait {
          return 3
        } else {
          return 4
        }
      } else {
        return 2
      }
    }()
    
    return UIScreen.main.bounds.width/constant
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AboutView()
      
      AboutView()
        .previewDevice("iPhone SE (2nd generation)")
      
      AboutView()
        .preferredColorScheme(.dark)
.previewInterfaceOrientation(.landscapeLeft)
    }
  }
}
