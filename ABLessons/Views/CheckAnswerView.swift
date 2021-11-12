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
  var viewModel : TaskViewModel
  @State var selfMark: Int// = 0
  @State var animation = false
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Capsule()
          .fill(Color.secondary)
          .frame(width: 30, height: 3)
          .padding(10)
        Spacer()
      }
      if viewModel.isAnswerRight() && false {
        RightAnswerView(viewModel: viewModel)
      } else {
        VStack(alignment: .leading) {
     //     if selfMark == 0 {
            Group {
              Text("Задание:").foregroundColor(.fontColor)
              Text(viewModel.task.textToTranslate!).font(.body)
              Divider()
              Text("Правильный перевод:").foregroundColor(.fontColor)
              Text(viewModel.task.translatedText!).font(.body)
              Divider()
              Text("Ваш перевод:").foregroundColor(.fontColor)
              Text(viewModel.taskTry.translatedText!).font(.body)
              Divider()
            }.padding(.leading).transition(.offset(y: -300))
    //      }
          Spacer()

          HStack {
            Spacer()
            if !viewModel.isAnswerRight() {
              Text("Поставьте себе оценку").foregroundColor(.fontColor).fontWeight(.bold)
            } else {
              Text("Верно!").foregroundColor(.fontColor).fontWeight(.bold)
            }
            Spacer()
          }
          HStack {
            Spacer()
            ZStack {
              HStack {
                ForEach(1...5, id: \.self) { index in
                  starImage(systemName: "star").onTapGesture {
                    withAnimation() {
                      self.selfMark = index
                    }
                  }
                }
              } // empty stars
              HStack {
                if selfMark > 0 {
                  ForEach(1...selfMark, id: \.self) { index in
                    starImage(systemName: "star.fill")
                      .scaleEffect(self.animation ? 1 : 0.1)
                      .animation(.stars(index: Int(index)))
                      .onTapGesture {
                          self.selfMark = index
                      }
                  }
                }//earned stars
                if selfMark < 5 {
                  ForEach((selfMark + 1)...5, id: \.self) { _ in
                    starImage(systemName: "star.fill")
                      .opacity(0)
                  }
                } //invisible stars for alignment
              } //full stars
            }
            Spacer()
          } // Звездочки
          if viewModel.taskTry.dictationBonus {
            HStack {
              Spacer()
              
              starImage(systemName: "star.fill")
                .padding(.top, 20)
                .scaleEffect(self.animation ? 1 : 0.001)
                .animation(.bonuses(index: 0))
              Text(" - голосовой ввод!")
                .font(.body)
                .padding(.top, 20)
                .scaleEffect(self.animation ? 1 : 0.001)
                .animation(.bonuses(index: 1))
                .foregroundColor(.fontColor)
           
              Spacer()
            }
          }
//          if viewModel.taskTry.dictationBonus {
//            Text("+ голосовой ввод").padding().foregroundColor(.fontColor)
//          }
          Spacer()
        }
      }//VStack
    }.onAppear {
      withAnimation {
        if self.viewModel.isAnswerRight() {
        //  viewModel.taskTry.selfMark = Int16(viewModel.stars)
          selfMark = viewModel.stars
        }
        self.animation.toggle()
      }
    }//wrong Answer
    
    if selfMark > 0 || viewModel.isAnswerRight(){
        Button(action: {
          viewModel.taskTry.selfMark = Int16(self.selfMark)
          self.presentationMode.wrappedValue.dismiss()
        }) {
        Text("Дальше")
          .foregroundColor(.white)
          .font(.title2)
          .frame(maxWidth: .infinity, minHeight: CGFloat(75))
          .background(Color(.foregroundColor))
        }.buttonStyle(PlainButtonStyle())
    }
  } //body
} //CheckAnswerView




struct RightAnswerView: View {
  var viewModel: TaskViewModel
  @State var animation = false
  
  var body: some View {
    VStack (alignment: .center) {
      Spacer()
      ZStack {
        HStack {
          ForEach(1...5, id: \.self) { _ in
            starImage(systemName: "star")
          }
        } // empty stars
        HStack {
          ForEach(1...viewModel.stars, id: \.self) { index in
            starImage(systemName: "star.fill")
            .scaleEffect(self.animation ? 1 : 0)
            .animation(.stars(index: index))
          } //earned stars
          if viewModel.stars < 5 {
            ForEach((viewModel.stars + 1)...5, id: \.self) { _ in
              starImage(systemName: "star.fill")
              .opacity(0)
            }
          } //invisible stars for alignment
        } //full stars
      }
      if viewModel.taskTry.dictationBonus {
        Text("Бонус - Голосовой ввод!")
          .font(.body).fontWeight(.bold)
          .padding(.top, 30)
          .scaleEffect(self.animation ? 1 : 0.1)
          .animation(.bonuses(index: 0))
          .foregroundColor(.fontColor)
      }
      if viewModel.taskTry.dictionaryBonus {
        Text("Бонус - Без словаря!")
          .font(.body).fontWeight(.bold)
          .foregroundColor(.fontColor)
          .scaleEffect(self.animation ? 1 : 0.1)
          .animation(.bonuses(index: 1))
      }
      Spacer()
    }.onAppear {
        withAnimation {
          self.animation.toggle()
        }
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

 
