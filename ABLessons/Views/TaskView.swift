//
//  TaskView.swift
//  AB_english_b
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI
import Speech


struct TaskView: View {
  @Binding var task: LessonTask?
  @Binding var taskTry: TaskTry
//  @Binding var ready: Bool
//  @Binding var viewModel: TaskViewModel
  @EnvironmentObject var viewModel: TaskViewModel
  
  @State var speechListening = false
  @State var speechRecognizing = false
  @State var isShowingPermittionAlert = false
//  @State var showEditor = false
//  @State var showColoredAnswer = false
//  @State var showDictionary = false
    
  @State private var speechRec: SpeechRec?
  
  private var isDictionaryAvailable: Bool {
    task!.dictionary != nil
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Group {
                
        Text(task!.textToTranslate!)
          .fixedSize(horizontal: false, vertical: true)
          .font(.body)
          .padding()        
        Divider()

        if viewModel.showEditor {
          MultilineTextField("", text: $taskTry.translatedText, onCommit: {
            viewModel.showEditor = false
            viewModel.isAnswerReady = taskTry.translatedText != ""
            
          }).padding()
        }
        else {
          if taskTry.translatedText != "" {
            if viewModel.showColoredAnswer {
              task!.answerText(taskTry: taskTry)
                .padding()
            } else {
              Text(taskTry.translatedText)
                .padding()
            }
            Divider()
          }
        }
        
      } //Q&A
      Spacer()

      if !viewModel.showEditor {
        HStack {
          Spacer()
            if speechRecognizing {
              VStack {
                ProgressView().scaleEffect(x: 1.5, y: 1.5)
                Text(viewModel.waitingMessage)
                  .padding(.top, 15)
                  .font(.footnote)
              }
            } else {
              Button(action: {
                if let speechRec = self.speechRec, speechRec.isRunning {
                  speechRec.stop()
                  self.speechListening = false
                  self.speechRecognizing = true
                  viewModel.isRecognizing = true
                  viewModel.setWaitingMessage()
                } else {
                  if self.speechRec != nil {
                    self.speechListening = true
                    self.speechRec!.start()
                  }
                }
              }) {
                Image(systemName: "mic")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .padding(20)
                         .frame(width: 110  , height: 110)
                  .foregroundColor(self.speechListening ? .red : .foregroundColor)
              

              }.alert(isPresented: self.$isShowingPermittionAlert) {
                  Alert(title: Text("This app must have access to speech recognition to work."), message: Text("Please consider updating your settings."), primaryButton: .default(Text("Open settings"), action: {UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                  }), secondaryButton: .cancel())
              }
            }
  //        }
          Spacer()
        }  //Speech Listning/recognition status
      }
      Spacer()
      
      if viewModel.showDictionary {
        Text(task!.dictionary!)
          .fixedSize(horizontal: false, vertical: true)
          .transition(.appearAndFade)
          .font(.body)
          .padding()
      } //Dictionary

      if !viewModel.showEditor {
        HStack {
          Spacer()
          
          
          Button(action: {
            viewModel.isAnswerReady = false
            self.toggleShowEditor()
          }) {
            icon(systemName: viewModel.showEditor ? "pencil.circle.fill" : "pencil.circle")
          }.disabled(speechListening || speechRecognizing)
          Spacer()
          
          if isDictionaryAvailable {
            Button(action : {
                withAnimation {
                  self.toggleShowDictionary()
                }
            }) {
              icon(systemName: viewModel.showDictionary ? "book.fill" : "book")
            }
            Spacer()
          }

          Button(action : {
            withAnimation {
              self.toggleColoredAnswer()
            }
          }) {
            icon(systemName: viewModel.showColoredAnswer ? "lightbulb.fill" : "lightbulb")
          }
          Spacer()
          
        }.border(Color.gray, width: 1)
         .background(Color(UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)))
         .frame(height: 75)
      } // bottom toolbar
    }.contentShape(Rectangle())
    .padding(0).onAppear {
      self.speechRec = SpeechRec(showPermittionAlert: self.$isShowingPermittionAlert, onFinished:
        { result, error in
            self.speechRecognizing = false
            self.viewModel.isRecognizing = false
            if let error = error {
              print("Error: \(error.localizedDescription)")
           //   self.viewModel.taskTry.translatedText = "Ошибка распознавания речи: " + error.localizedDescription
              return
            }
          self.taskTry.translatedText = result
          self.viewModel.isAnswerReady = result != ""
          self.speechRec!.cancelTask()
        })
    } //VStack
    
  }
  
  
  
  func toggleShowDictionary() {
    if !task!.isAnswerRight(taskTry: taskTry) {
      taskTry.dictionaryBonus = false
    }
    viewModel.showDictionary.toggle()
  }
//
  func toggleShowEditor() {
    if !task!.isAnswerRight(taskTry: taskTry) {
      taskTry.dictationBonus = false
    }
    viewModel.showEditor.toggle()
  }
//
  func toggleColoredAnswer() {
    if !task!.isAnswerRight(taskTry: taskTry) {
      taskTry.coloredAnswerBonus = false
    }
    viewModel.showColoredAnswer.toggle()
  }
  
  
  
  func icon(systemName: String, size: CGFloat = 75) -> some View {
    return Image(systemName: systemName)
             .resizable()
             .aspectRatio(contentMode: .fit)
             .padding(20)
             .frame(width: size, height: size)
             .foregroundColor(Color(.foregroundColor))
  }
  
      
}



