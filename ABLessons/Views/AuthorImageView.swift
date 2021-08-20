//
//  AuthorImageView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct AuthorImageView: View {
  var image: UIImage?
  var size: CGFloat = 60.0
    var body: some View {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .clipShape(Circle())
          .frame(width: size, height: size)
          .shadow(radius: size > 40 ? 10 : 0)
          .overlay(Circle().stroke(Color.white, lineWidth: size > 40 ? 3 : 1))
      }
    }
}


