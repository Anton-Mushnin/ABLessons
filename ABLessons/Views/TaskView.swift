//
//  TaskView.swift
//  AB_english_b
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI
import Speech



func icon(systemName: String, size: CGFloat = 75) -> some View {
  return Image(systemName: systemName)
           .resizable()
           .aspectRatio(contentMode: .fit)
           .padding(20)
           .frame(width: size, height: size)
           .foregroundColor(Color(.foregroundColor))
}








struct TaskView: View {
  @Binding var task: LessonTask?
  @Binding var taskTry: TaskTry
  @Binding var ready: Bool
  
  @State var speechListening = false
  @State var speechRecognizing = false
//  @State var isShowingRightAnswer = false
  @State var isShowingPermittionAlert = false
  @State var showEditor = false
  @State var showColoredAnswer = false
  @State var showDictionary = false
    
  private var isDictionaryAvailable: Bool {
    task!.dictionary != nil
  }
  

  
  
  func toggleShowDictionary() {
    if !task!.isAnswerRight(taskTry: taskTry) {
      taskTry.dictionaryBonus = false
    }
    showDictionary.toggle()
  }
//
  func toggleShowEditor() {
    if !task!.isAnswerRight(taskTry: taskTry) {
      taskTry.dictationBonus = false
    }
    showEditor.toggle()
  }
//
  func toggleColoredAnswer() {
    if !task!.isAnswerRight(taskTry: taskTry) {
      taskTry.coloredAnswerBonus = false
    }
    showColoredAnswer.toggle()
  }
  
//
//  func isAnswerRight() -> Bool {
//    let wordsFromAnswer = words(text: taskTry.translatedText)
//    let wordsFromTranslatedText = words(text: task.translatedText!)
//    if wordsFromAnswer.count != wordsFromTranslatedText.count {
//      return false
//    }
//    for (index, value) in wordsFromAnswer.enumerated() {
//          if wordsFromTranslatedText[index] != value {
//            return false
//          }
//    }
//    return true
//  }
  
  
  
  @State private var speechRec: SpeechRec?

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Group {
                
        Text(task!.textToTranslate!)
          .fixedSize(horizontal: false, vertical: true)
          .font(.body)
          .padding()
//          .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//              Text("\(viewModel.currentTask + 1) / \(viewModel.lesson.lessonTasksArray.count)")
//            }
//          }
        
        Divider()

        if showEditor {
          MultilineTextField("", text: $taskTry.translatedText, onCommit: {
            self.showEditor = false
            ready = taskTry.translatedText != ""
          }).padding()
        }
        else {
          if taskTry.translatedText != "" {
            if showColoredAnswer {
              task!.answerText(taskTry: taskTry).padding()
         //     Text(taskTry.translatedText).padding()
            } else {
              Text(taskTry.translatedText)
                .padding()
            }
            Divider()
          }
        }
        
      } //Q&A
      Spacer()

      if !showEditor {
        HStack {
          Spacer()
            if speechRecognizing {
              ProgressView().scaleEffect(x: 1.5, y: 1.5)
            } else {
              Button(action: {
                if let speechRec = self.speechRec, speechRec.isRunning {
                  speechRec.stop()
                  self.speechListening = false
                  self.speechRecognizing = true
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
      
//      if taskTry.translatedText != "" && !showEditor{
//        HStack {
//          Button(action: {
//       //     viewModel.taskTry.translatedText = viewModel.translatedText
//            self.isShowingRightAnswer = true
//          }) {
//          Text("Отправить!")
//            .foregroundColor(.white)
//            .font(.title2)
//            .frame(maxWidth: .infinity, minHeight: CGFloat(75))
//            .background(Color(.foregroundColor))
//          }.buttonStyle(PlainButtonStyle())
//           .fullScreenCover(isPresented: $isShowingRightAnswer, onDismiss: {
//           //   if !viewModel.forward() {
//      //      self.done = true
//           //   }
//            }) {
//    //        Text("CheckAnswerView")
//            CheckAnswerView(task: task, taskTry: taskTry)
//           }
//        }
//      } //Отправить button
      
      if showDictionary {
        Text(task!.dictionary!)
          .fixedSize(horizontal: false, vertical: true)
          .transition(.appearAndFade)
          .font(.body)
          .padding()
      } //Dictionary

      if !showEditor {
        HStack {
          Spacer()
          
          
          Button(action: {
            ready = false
            self.toggleShowEditor()
          }) {
            icon(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")
          }.disabled(speechListening || speechRecognizing)
          Spacer()
          
          if isDictionaryAvailable {
            Button(action : {
                withAnimation {
                  self.toggleShowDictionary()
                }
            }) {
              icon(systemName: self.showDictionary ? "book.fill" : "book")
            }
            Spacer()
          }

          Button(action : {
          //  self.viewModel.toggleColoredAnswer()
            self.toggleColoredAnswer()
          }) {
            icon(systemName: self.showColoredAnswer ? "lightbulb.fill" : "lightbulb")
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
            if let error = error {
              print("Error: \(error.localizedDescription)")
           //   self.viewModel.taskTry.translatedText = "Ошибка распознавания речи: " + error.localizedDescription
              return
            }
          self.taskTry.translatedText = result
          self.ready = result != ""
          self.speechRec!.cancelTask()
        })
    } //VStack
    
  }
      
}



