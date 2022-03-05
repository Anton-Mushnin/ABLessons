//
//  RepeatingTasksView.swift
//  ABLessons
//
//  Created by Антон Мушнин on 23.02.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct RepeatingTasksView: View {
  @StateObject var viewModel: RepeatingTasksViewModel
  @StateObject var taskViewModel = TaskViewModel()
  @State var isShowingRightAnswer = false
  @Environment(\.presentationMode) var presentationMode

  
  
    var body: some View {
      VStack(spacing: 0) {
        TaskView(task: $viewModel.task, taskTry: $viewModel.taskTry).environmentObject(taskViewModel)
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
            }.disabled(taskViewModel.isListening)
             .buttonStyle(PlainButtonStyle())
             .contentShape(Rectangle())
             .fullScreenCover(isPresented: $isShowingRightAnswer, onDismiss: {
              taskViewModel.newTask()
              if !viewModel.nextTask() {
                presentationMode.wrappedValue.dismiss()
              }
              }) {
              CheckAnswerView(task: viewModel.task!, taskTry: viewModel.taskTry)
             }
          }
        }
      }
    }
}


