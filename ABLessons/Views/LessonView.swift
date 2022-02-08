//
//  LessonView.swift
//  ABLessons
//
//  Created by Антон Мушнин on 28.01.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct LessonView: View {
  @StateObject var viewModel: LessonViewModel
  @Environment(\.presentationMode) var presentationMode
  @State var isShowingRightAnswer = false
  @State var readyToSubmit = false
  @State var isShowingScoresInfo = false
  @StateObject var taskViewModel = TaskViewModel()
  
  
    var body: some View {
      VStack {
        switch viewModel.stage {
        case .text:
          
          ZStack {
            HTMLStringView(htmlContent: viewModel.text)
              .padding(.leading, 10)
              .padding(.trailing, 10)
              .padding(.top, 5)
            if viewModel.numberOfPages > 1 {
              VStack {
                Spacer()
                VisualEffectView(effect: UIBlurEffect(style: .extraLight))
                  .frame(height: 40)
              }
              VStack {
                Spacer()
                PageControlView(numberOfPages: viewModel.numberOfPages, currentPage: $viewModel.currentText)
                  .padding(15)
              }
            }
          }
          
        case .task:
          if let task = viewModel.task {
            VStack(spacing: 0) {
              
              TaskView(task: $viewModel.task, taskTry: $viewModel.taskTry).environmentObject(taskViewModel)//, viewModel: $taskViewModel)
              if taskViewModel.isAnswerReady {
                HStack {
                  Button(action: {
                    self.isShowingRightAnswer = true
                  }) {
                  Text("Отправить!")
                    .foregroundColor(.white)
                    .font(.title2)
                    .frame(maxWidth: .infinity, minHeight: CGFloat(75))
                    .background(Color(.foregroundColor))
                  }.buttonStyle(PlainButtonStyle())
                   .contentShape(Rectangle())
                   .fullScreenCover(isPresented: $isShowingRightAnswer, onDismiss: {
                    taskViewModel.newTask()
                    viewModel.nextTask()
                    }) {
                    CheckAnswerView(task: viewModel.task!, taskTry: viewModel.taskTry)
                   }
                }
              } //Отправить button
            }
          }
        case .score:
          VStack(spacing: 0) {
            LessonSubmissionsView(submissions: viewModel.submissions)
    //        Spacer()
            Button(action: {
              self.presentationMode.wrappedValue.dismiss()
            }) {
            Text("Всё!")
              .foregroundColor(.white)
              .font(.title2)
              .frame(maxWidth: .infinity, minHeight: CGFloat(75))
              .background(Color(.foregroundColor))
            }.buttonStyle(PlainButtonStyle())
          }
        }
      }.contentShape(Rectangle())
       .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                            .onEnded({ value in
                              if value.translation.width < 0 {
                                  viewModel.next()
                              }
                              if value.translation.width > 0 {
                                  viewModel.previous()
                              }
                            }))
        .toolbar {
          ToolbarItemGroup(placement: .navigationBarTrailing) {
            if viewModel.stage != .score {
              Button(viewModel.toolbarButtonCaption) {
                if !viewModel.toolbarButtonPressed() {
                  self.presentationMode.wrappedValue.dismiss()
                }
              }
            } else {
              Button(action: {
                isShowingScoresInfo = true
              }) {
                Image(systemName: "info.circle")
              }
            }
              
          }
        }
       
    }
}



struct PageControlView: View {
  var numberOfPages: Int
  @Binding var currentPage: Int
  
  var body: some View {
    HStack {
      ForEach (0 ..< numberOfPages) { page in
        Image(systemName: "circle.fill")
          .resizable()
          .frame(width: 8, height: 8)
          .foregroundColor(page == currentPage ? .fontColor : .inactiveColor)
      }
    }
  }
}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

