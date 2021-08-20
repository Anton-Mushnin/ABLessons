//
//  LessonTask+CoreDataExtension.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI

extension LessonTask {



public var wrappedTranslatedText: String {
  translatedText ?? ""
}

public var wrappedTextToTranslate: String {
  textToTranslate ?? ""
}

public var wrappedDictionary: String {
  dictionary ?? ""
}

public var triesArray: [TaskTry] {
  let set = tries as? Set<TaskTry> ?? []
  return Array(set)
}


/*func convertToTask() -> Task {
  Task(id: self.id!,
       textToTranslate: textToTranslate!,
       translatedText: translatedText!,
       dictionary: dictionary)
}
 */


func isRightAnswer(answer: String) -> Bool {
  let wordsFromAnswer = words(text: answer)
  let wordsFromTranslatedText = words(text: wrappedTranslatedText)
  if wordsFromAnswer.count != wordsFromTranslatedText.count {
    return false
  }
  for (index, value) in wordsFromAnswer.enumerated() {
    if wordsFromTranslatedText.firstIndex(of: value) != nil {
        if wordsFromTranslatedText[index] != value {
          return false
        }
      } else {
        return false
      }
  }
  return true
}


func coloredText(answer: String) -> Text {
  var text = Text("")
  let wordsFromAnswer = words(text: answer)
  let wordsFromTranslatedText = words(text: wrappedTranslatedText)
  for (index, value) in wordsFromAnswer.enumerated() {
    if index > 0 {
      text = text + Text(" ")
    }
    if wordsFromTranslatedText.firstIndex(of: value) != nil {
      if index < wordsFromTranslatedText.count,  wordsFromTranslatedText[index] == value {
          text = text + Text(value).foregroundColor(Color.green)
        } else {
          text = text + Text(value).foregroundColor(Color.orange)
        }
      } else {
        text = text + Text(value).foregroundColor(Color.red)
      }
  }
  return text
  
}

func words(text: String) -> [String.SubSequence] {
  let punctuations: Set<Character> = [",", ".", "!", ";", "\"", "?", "”", "“"]
  var cleanText = text.uppercased()
  cleanText.removeAll(where: {punctuations.contains($0)})
  return cleanText.split(separator: " ")
}


}
