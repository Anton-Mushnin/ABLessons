//
//  StarsEditView.swift
//  ABLessons
//
//  Created by Антон Мушнин on 22.02.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import SwiftUI


struct StarsEditView: View {
  @Binding var stars: Int
  var body: some View {
    ZStack {
      HStack {
        ForEach(1...5, id: \.self) { index in
          Image(systemName: "star").onTapGesture {
            stars = index
          }.foregroundColor(.yellow)
        }
      }
      HStack {
        if (stars > 0) {
          ForEach(1...stars, id: \.self) { index in
            Image(systemName: "star.fill").onTapGesture {
              stars = index
            }.foregroundColor(.yellow)
          }
        }
        if stars < 5 {
          ForEach((stars + 1)...5, id: \.self) { _ in
            Image(systemName: "star.fill")
              .opacity(0)
          }
        }
      }
    }
  }
}
