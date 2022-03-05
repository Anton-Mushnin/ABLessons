//
//  CheckAnswerView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI





struct CheckAnswerView: View {
  @Environment(\.presentationMode) var presentationMode
  var task: LessonTask
  var taskTry: TaskTry

  @State var selfMark = 0
  @State var animation = false
  
  var body: some View {
    VStack {
      Rectangle().fill(Color.clear).frame(height: 20)
      
      VStack(alignment: .leading) {
        Group {
          Divider()
          TaskItemView(title: "Задание:", text: task.textToTranslate!)
          TaskItemView(title: "Правильный перевод:", text: task.translatedText!)
          TaskItemView(title: "Ваш перевод:", text: taskTry.translatedText)
        }.padding(.leading).padding(.trailing)
        Spacer()
        HStack {
          Spacer()
          Text(task.isAnswerRight(taskTry: taskTry) ? "Верно" : "Поставьте себе оценку")
            .foregroundColor(.fontColor).fontWeight(.bold)
          Spacer()
        }
        StarsView(stars: $selfMark, animation: $animation)
        if taskTry.dictationBonus {
          HStack {
            Spacer()
            Image(systemName: "star.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 20, height: 20)
              .foregroundColor(.foregroundColor)
              .scaleEffect(self.animation ? 1 : 0.001)
              .padding(.top, 15)
              .animation(.bonuses(index: 0))
            Text(" - голосовой ввод!")
              .font(.body)
              .padding(.top, 15)
              .scaleEffect(self.animation ? 1 : 0.001)
              .animation(.bonuses(index: 1))
              .foregroundColor(.fontColor)
            Spacer()
          }
        }
        Spacer()
      }

    }.onAppear {
      if task.isAnswerRight(taskTry: taskTry) {
        selfMark = 5
      }
      withAnimation {
          self.animation = true
      }
    }//wrong Answer
    
 
    Button(action: {
      taskTry.selfMark = Int16(self.selfMark)
      self.presentationMode.wrappedValue.dismiss()
    }) {
    Text("Дальше")
      .foregroundColor(.white)
      .font(.title2)
      .frame(maxWidth: .infinity, minHeight: CGFloat(75))
      .background(Color(.foregroundColor))
    }.buttonStyle(PlainButtonStyle())
     .disabled(!(selfMark > 0))

  } //body
} //CheckAnswerView


struct TaskItemView: View {
  @State var title: String
  @State var text: String
  
  var body: some View {
    Text(title).foregroundColor(.fontColor)
    Text(text).font(.body)//.padding(5)
    Divider()
  }
}


struct StarsView: View {
  @Binding var stars: Int
  @Binding var animation: Bool
  var body: some View {
    HStack {
      Spacer()
      ZStack {
        HStack {
          ForEach(1...5, id: \.self) { index in
            starImage(systemName: "star").onTapGesture {
              withAnimation() {
                stars = index
              }
            }
          }
        } // empty stars
        HStack {
          if stars > 0 {
            ForEach(1...stars, id: \.self) { index in
              starImage(systemName: "star.fill")
                .scaleEffect(animation ? 1 : 0.1)
                .animation(.stars(index: Int(index)))
                .onTapGesture {
                    self.stars = index
                }
            }
          }//earned stars
          if stars < 5 {
            ForEach((stars + 1)...5, id: \.self) { _ in
              starImage(systemName: "star.fill")
                .opacity(0)
            }
          } //invisible stars for alignment
        } //filled stars
      }
      Spacer()
    }
  }
}





func starImage(systemName: String) -> some View {
  return Image(systemName: systemName)
  .resizable()
  .aspectRatio(contentMode: .fit)
  .frame(width: 30, height: 30)
  .foregroundColor(.yellow)
}



