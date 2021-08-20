//
//  LessonSubmissionExt.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation



extension LessonSubmission {
  
  
  public var taskTriesArray: [TaskTry] {
    let set = taskTries as? Set<TaskTry> ?? []
    return Array(set)
  }
  
  public func calculateScore() -> Void {
    var score = 0.0
    for taskTry in taskTriesArray {
      score = score + Double(taskTry.score())
    }
    score = score * 100 / (Double(taskTriesArray.count) * 100)
    score = (score * 100).rounded() / 100
    self.score = score
  }
  
}
