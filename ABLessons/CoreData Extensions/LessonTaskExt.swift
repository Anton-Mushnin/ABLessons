//
//  TaskExt.swift
//  ABLessons
//
//  Created by Антон Мушнин on 31.01.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI


extension LessonTask {
  
  
  public func isAnswerRight(taskTry: TaskTry) -> Bool {
    let wordsFromAnswer = words(text: taskTry.translatedText)
      let wordsFromTranslatedText = words(text: translatedText!)
      if wordsFromAnswer.count != wordsFromTranslatedText.count {
        return false
      }
      for (index, value) in wordsFromAnswer.enumerated() {
            if wordsFromTranslatedText[index] != value {
              return false
            }
      }
      return true
  }
  
  
  
  private func words(text: String) -> [String.SubSequence] {
    let textWithoutNBSP = text.replacingOccurrences(of: " ", with: " ")
    var cleanText = textWithoutNBSP.uppercased()
    let punctuations: Set<Character> = [",", ".", "!", ";", "\"", "?", "”", "“","'","`","’", "-", "—", "–"]
    cleanText.removeAll(where: {punctuations.contains($0)})
    return cleanText.split(separator: " ")
  }
  
  func answerText(taskTry: TaskTry) -> Text {
    var text = Text("")
//    if showColoredAnswer {
      let originalWordsFromAnswer = taskTry.translatedText.split(separator: " ")
      let wordsFromAnswer = words(text: taskTry.translatedText)
      let wordsFromTranslatedText = words(text: translatedText!)
      for (index, value) in wordsFromAnswer.enumerated() {
        if index > 0 {
          text = text + Text(" ")
        }
        if wordsFromTranslatedText.firstIndex(of: value) != nil {
          if index < wordsFromTranslatedText.count,  wordsFromTranslatedText[index] == value {
              text = text + Text(originalWordsFromAnswer[index]).foregroundColor(.green)
            } else {
              text = text + Text(originalWordsFromAnswer[index]).foregroundColor(.orange)
            }
          } else {
            text = text + Text(originalWordsFromAnswer[index]).foregroundColor(.red)
          }
      }
//    } else {
//      text = Text(translatedText)
//    }
    return text
  }
  
  
}
  

