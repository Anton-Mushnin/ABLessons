//
//  ScoreInfoView.swift
//  ABLessons
//
//  Created by Антон Мушнин on 18.02.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct ScoreInfoView: View {
    var body: some View {
      VStack(alignment: HorizontalAlignment.leading) {
        HStack {
          Spacer()
          Capsule()
            .fill(Color.secondary)
            .frame(width: 30, height: 3)
            .padding(10)
          Spacer()
        }.padding(.bottom, 25)
        Group {
          Text("за каждую звездочку даётся 20 баллов")
          Text("за использование лампочки снимается 20 баллов")
          Text("за голосовой ввод даётся 5 баллов")
          Text("не забывайте повторять правильный перевод несколько раз - эмоционально, бегло, с хорошим произношением!").padding(.top, 20)
        }.foregroundColor(.fontColor).padding(.leading, 25).padding(.trailing, 25).padding(.bottom, 10)
        Spacer()
      }

    }
}

