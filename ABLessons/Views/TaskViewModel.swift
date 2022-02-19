//
//  TaskViewModel.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData



class TaskViewModel: ObservableObject {
  @Published var showDictionary = false
  @Published var showColoredAnswer = false
  @Published var showEditor = false
  @Published var isAnswerReady = false
  @Published var waitingMessage = ""
  var isRecognizing = false
  @Published var isListening = false
  var waitingMessagesToPick = waitingMessages
  
  func newTask() {
    showDictionary = false
    showColoredAnswer = false
    showEditor = false
    isAnswerReady = false
  }
  
  func setWaitingMessage() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
      if self.isRecognizing {
        
        if waitingMessagesToPick.count == 0 {
          waitingMessagesToPick = TaskViewModel.waitingMessages
        }
        
        if let randomIndex = self.waitingMessagesToPick.indices.randomElement() {
          waitingMessage =  waitingMessagesToPick[randomIndex]
          waitingMessagesToPick.remove(at: randomIndex)
        }
        self.setWaitingMessage()
      } else {
          waitingMessage = ""
      }
    }
    
  }
  
  static private var waitingMessages = [
                                        "что-то долго в этот раз…",
                                        "не всегда быстро получается…",
                                        "уже скоро...",
                                        "ещё чуть-чуть…",
                                        "немножко осталось…",
                                        "стараюсь получше распознать…",
                                        "не всё хорошо понятно тут…",
                                        "так бывает у меня, что не сразу распознаётся…",
                                        "со связью что-то, наверно…",
                                        "мне даже как-то неудобно, что так долго…",
                                        "ещё немножко…",
                                        "почти всё уже…",
                                        "сложное упражнение…",
                                        "надеюсь, хотя бы правильно получится…",
                                        "ваш текст очень важен для нас…",
                                        "это кончится когда-нибудь…",
                                        "не очень быстро в этот раз, да?",
                                        "сама не знаю, почему так долго…",
                                        "что-то не получается…",
                                        "интересно, что получится…",
                                        "сложные слова…",
                                        "немножко запуталась…",
                                        "сейчас-сейчас…",
                                        "ох, сложно…",
                                        "сколько-то процентов точно готово…",
                                        "я думала, проще будет…",
                                        "вы на английском это произнесли?",
                                        "простите, отвлекают...",
                                        "5... 4... 3... 2... 1...",
                                        "переслушиваю снова и снова...",
                                        "приятный голос у вас...",
                                        "интересные задания вам задают...",
                                        "переключаюсь на перцептрон Розенблатта...",
                                        "включаю неокогнитрон...",
                                        "подключаюсь к сети адаптивного резонанса...",
                                        "почти всё понятно...",
                                        "два варианта хороших, не могу один выбрать...",
                                        "пока ещё не всё...",
                                        "может быть уже больше половины разобрала...",
                                        "два словечка осталось...",
                                        "пытаюсь запятые расставить...",
                                        "хочется Алисе позвонить в такие моменты...",
                                        "не могу пока сказать, что получилось...",
                                        "что-то я не уверена, что уже готово...",
                                        "подумаю ещё секундочку, хорошо?",
                                        "подбираю парадигматические формы...",
                                        "редкий алломорф тут у вас...",
                                        "температура процессора в норме..."
    ]
  
  
}




