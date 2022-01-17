//
//  TaskView.swift
//  AB_english_b
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI
import Speech



func icon(systemName: String) -> some View {
  return Image(systemName: systemName)
           .resizable()
           .aspectRatio(contentMode: .fit)
           .padding(20)
           .frame(width: 75, height: 75)
           .foregroundColor(Color(.foregroundColor))
}



struct TaskView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) var moc
  @StateObject var viewModel: TaskViewModel
  
  @State var done = false
  
  @State var speechListening = false
  @State var speechRecognizing = false
  @State var isShowingRightAnswer = false
  @State var isShowingPermittionAlert = false
    
  private var isDictionaryAvailable: Bool {
    viewModel.task.dictionary != nil
  }
  
  @State private var speechRec: SpeechRec?

  var body: some View {
    
    if done {
      LessonSubmissionsView(lesson: viewModel.lesson)
    } else {
        
      VStack(alignment: .leading, spacing: 0) {
        Group {
                  
          Text(viewModel.task.textToTranslate!)
            .fixedSize(horizontal: false, vertical: true)
            .font(.body)
            .padding().toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(viewModel.currentTask + 1) / \(viewModel.lesson.lessonTasksArray.count)")
              }
            }
          
          Divider()

          if viewModel.showEditor {
            MultilineTextField("", text: $viewModel.translatedText, onCommit: {
              self.viewModel.toggleShowEditor()
            }).padding()
          } else {
            if viewModel.showColoredAnswer {
              viewModel.answerText().padding()
            } else {
              Text(viewModel.translatedText)
                .padding()
            }
          }
          
          if viewModel.translatedText != "" {
            Divider()
          }
          
        }
        Spacer()

        HStack {
          Spacer()
          if speechListening || speechRecognizing {
            if speechRecognizing {
              ProgressView()
            } else {
              icon(systemName: speechListening ? "ear" : "hourglass.bottomhalf.fill")
            }
          }
          Spacer()
        }
        Spacer()
        
        if viewModel.translatedText != "" && !viewModel.showEditor{
          HStack {
            Button(action: {
              viewModel.taskTry.translatedText = viewModel.translatedText
              self.isShowingRightAnswer = true
            }) {
            Text("Отправить!")
              .foregroundColor(.white)
              .font(.title2)
              .frame(maxWidth: .infinity, minHeight: CGFloat(75))
              .background(Color(.foregroundColor))
            }.buttonStyle(PlainButtonStyle())
             .fullScreenCover(isPresented: $isShowingRightAnswer, onDismiss: {
                if !viewModel.forward() {
                  done = true
                }
              }) {
              CheckAnswerView(viewModel: viewModel, selfMark: viewModel.stars)
             }
          }
        }
        
        if viewModel.showDictionary {
          Text(viewModel.task.dictionary!)
            .fixedSize(horizontal: false, vertical: true)
            .transition(.appearAndFade)
            .font(.body)
            .padding()
        }

        if !viewModel.showEditor {
          HStack {
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
              icon(systemName: self.speechListening ? "mic.fill" : "mic")
            }.alert(isPresented: self.$isShowingPermittionAlert) {
                Alert(title: Text("This app must have access to speech recognition to work."), message: Text("Please consider updating your settings."), primaryButton: .default(Text("Open settings"), action: {UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }), secondaryButton: .cancel())
            }
            Spacer()
            
            Button(action: {
              self.viewModel.toggleShowEditor()
            }) {
              icon(systemName: viewModel.showEditor ? "pencil.circle.fill" : "pencil.circle")
            }.disabled(speechListening || speechRecognizing)

            if isDictionaryAvailable {
              Spacer()
              Button(action : {
                  withAnimation {
                    self.viewModel.toggleShowDictionary()
                  }
              }) {
                icon(systemName: self.viewModel.showDictionary ? "book.fill" : "book")
              }
            }
            Spacer()
            
            Button(action : {
              self.viewModel.toggleColoredAnswer()
            }) {
              icon(systemName: self.viewModel.showColoredAnswer ? "lightbulb.fill" : "lightbulb")
            }
            
          }.border(Color.gray, width: 1)
           .background(Color(UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)))
           .frame(height: 75)
        }
      }.padding(0).onAppear {
        self.speechRec = SpeechRec(showPermittionAlert: self.$isShowingPermittionAlert, onFinished:
          { result, error in
              self.speechRecognizing = false
              if let error = error {
                self.viewModel.taskTry.translatedText = "Ошибка распознавания речи: " + error.localizedDescription
                return
              }
            self.viewModel.translatedText = result
            self.speechRec!.cancelTask()
          })
      } //VStack
    }
  }
      
}



