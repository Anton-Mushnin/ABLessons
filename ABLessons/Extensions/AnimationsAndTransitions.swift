//
//  AnimationsAndTransitions.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI

extension Animation {
  static func stars(index: Int) -> Animation {
    Animation.spring(response: 1, dampingFraction: 0.3,
                     blendDuration: 0.5)
      .speed(3)
      .delay(0.3 + 0.15 * Double(index))
    }
}

extension Animation {
  static func bonuses(index: Int) -> Animation {
    Animation.spring(response: 1, dampingFraction: 0.3,
                     blendDuration: 0.5)
      .speed(3)
      .delay(1.3 + 0.4 * Double(index))
    }
}


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
  
  static var appearAndFade: AnyTransition {
      let insertion = AnyTransition.scale
          .combined(with: .opacity)
      let removal = AnyTransition.scale
          .combined(with: .opacity)
      return .asymmetric(insertion: insertion, removal: removal)
  }
  
  
}


