//
//  UIApplication+MainWindow.swift
//  HeadwayTest
//
//  Created by Danil on 01.08.2022.
//

import UIKit

extension UIApplication {
  var mainWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .first(where: { $0 is UIWindowScene })
      .flatMap({ $0 as? UIWindowScene })?.windows
      .first(where: \.isKeyWindow)
  }
}
