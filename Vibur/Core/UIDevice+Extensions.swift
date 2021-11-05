//
//  UIDevice+Extensions.swift
//  Vibur
//
//  Created by Kristaps Grinbergs on 05/11/2021.
//

import Foundation
import UIKit

extension UIDevice {
  
  static var idiom: UIUserInterfaceIdiom {
    UIDevice.current.userInterfaceIdiom
  }
  
  static var isIpad: Bool {
    idiom == .pad
  }
  
  static var isPortrait: Bool {
    UIDevice.current.orientation.isPortrait
  }
}
