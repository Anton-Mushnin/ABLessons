//
//  TaskTryExt.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation


extension TaskTry {
  public var wrappedTranslatedText: String {
    translatedText// ?? ""
  }
  

  func score() -> Int16 {
    var score: Int16 = 0
    if selfMark > 0 {
      score = (selfMark - 1) * 20
    } else {
      if rightAnswer {
        score += 80
      }
    }
    
    if score > 0 {
      if dictionaryBonus {
        score += 5
      }
      if dictationBonus {
        score += 5
      }
      if coloredAnswerBonus {
        score += 20
      }
    }
    return score
  }
  
}
