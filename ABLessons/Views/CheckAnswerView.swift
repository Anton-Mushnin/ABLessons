//
//  CheckAnswerView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI


struct TaskItemView: View {
  @State var title: String
  @State var text: String
  var body: some View {
    Text(title).foregroundColor(.fontColor)
  //  Rectangle().fill(Color.clear)//.frame(height: 5)
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


struct CheckAnswerView: View {
  @Environment(\.presentationMode) var presentationMode
  var task: LessonTask
  var taskTry: TaskTry
//  var viewModel : TaskViewModel
//  @State var selfMark: Int// = 0
  @State var selfMark = 0
  @State var animation = false
  
  var body: some View {
    VStack {
//      if viewModel.isAnswerRight() && false {
//        RightAnswerView(viewModel: viewModel)
//      } else {
      
      Rectangle().fill(Color.clear).frame(height: 20)
   //   Rectangle().fill(Color.foregroundColor).frame(height: 37).edgesIgnoringSafeArea(.horizontal)
  //    Rectangle().fill(Color.clear).frame(height: 15)
      
        VStack(alignment: .leading) {
     //     Spacer()
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
//      }//VStack
    }.onAppear {
      if task.isAnswerRight(taskTry: taskTry) {
        selfMark = 5
      }
      withAnimation {
          self.animation = true
      }
    }//wrong Answer
    
 //   if selfMark > 0 || viewModel.isAnswerRight(){
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
//    }
  } //body
} //CheckAnswerView




//struct RightAnswerView: View {
//  var viewModel: TaskViewModel
//  @State var animation = false
//  
//  var body: some View {
//    VStack (alignment: .center) {
//      Spacer()
//      ZStack {
//        HStack {
//          ForEach(1...5, id: \.self) { _ in
//            starImage(systemName: "star")
//          }
//        } // empty stars
//        HStack {
//          ForEach(1...viewModel.stars, id: \.self) { index in
//            starImage(systemName: "star.fill")
//            .scaleEffect(self.animation ? 1 : 0)
//            .animation(.stars(index: index))
//          } //earned stars
//          if viewModel.stars < 5 {
//            ForEach((viewModel.stars + 1)...5, id: \.self) { _ in
//              starImage(systemName: "star.fill")
//              .opacity(0)
//            }
//          } //invisible stars for alignment
//        } //full stars
//      }
//      if viewModel.taskTry.dictationBonus {
//        Text("Бонус - Голосовой ввод!")
//          .font(.body).fontWeight(.bold)
//          .padding(.top, 30)
//          .scaleEffect(self.animation ? 1 : 0.1)
//          .animation(.bonuses(index: 0))
//          .foregroundColor(.fontColor)
//      }
//      if viewModel.taskTry.dictionaryBonus {
//        Text("Бонус - Без словаря!")
//          .font(.body).fontWeight(.bold)
//          .foregroundColor(.fontColor)
//          .scaleEffect(self.animation ? 1 : 0.1)
//          .animation(.bonuses(index: 1))
//      }
//      Spacer()
//    }.onAppear {
//        withAnimation {
//          self.animation.toggle()
//        }
//      }
//  }
//}

func starImage(systemName: String) -> some View {
  return Image(systemName: systemName)
  .resizable()
  .aspectRatio(contentMode: .fit)
  .frame(width: 30, height: 30)
  .foregroundColor(.yellow)
}



//func isAnswerRight(answer: String, ref: String) -> Bool {
//  let wordsFromAnswer = words(text: answer)
//  let wordsFromTranslatedText = words(text: ref)
//  if wordsFromAnswer.count != wordsFromTranslatedText.count {
//    return false
//  }
//  for (index, value) in wordsFromAnswer.enumerated() {
//        if wordsFromTranslatedText[index] != value {
//          return false
//        }
//  }
//  return true
//}


//func words(text: String) -> [String.SubSequence] {
//  let textWithoutNBSP = text.replacingOccurrences(of: " ", with: " ")
//  var cleanText = textWithoutNBSP.uppercased()
//  let punctuations: Set<Character> = [",", ".", "!", ";", "\"", "?", "”", "“","'","`","’", "-", "—", "–"]
//  cleanText.removeAll(where: {punctuations.contains($0)})
//  return cleanText.split(separator: " ")
//}
//


