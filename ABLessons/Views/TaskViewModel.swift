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
  @Published var translatedText = ""
  
  var lesson: Lesson
  let context: NSManagedObjectContext

  var taskTry: TaskTry
  var submission: LessonSubmission
  
  var currentTask = 0
  var task: LessonTask {
    lesson.lessonTasksArray[currentTask]
  }

  var progress: String {
    "\(currentTask + 1) / \(lesson.lessonTasksArray.count)"
  }
  
  
  init(lesson: Lesson, context: NSManagedObjectContext) {
    self.context = context
    self.lesson = lesson
    taskTry  = TaskTry(context: context)
    if let lastSubmission = lesson.lessonSubmissionsArray.last, lastSubmission.taskTriesArray.count < lesson.lessonTasksArray.count {
        submission = lastSubmission
        currentTask = lastSubmission.taskTriesArray.count
    } else {
      submission = LessonSubmission(context: context)
      submission.date = Date()
    }
    taskTry.dictionaryBonus = lesson.lessonTasksArray[currentTask].dictionary != nil
  }
 
  

  func toggleShowDictionary() {
    if !isAnswerRight() {
      taskTry.dictionaryBonus = false
    }
    showDictionary.toggle()
  }
  
  func toggleShowEditor() {
    if !isAnswerRight() {
      taskTry.dictationBonus = false
    }
    showEditor.toggle()
  }
  
  func toggleColoredAnswer() {
    if !isAnswerRight() {
      taskTry.coloredAnswerBonus = false
    }
    showColoredAnswer.toggle()
  }
  


  
  func forward() -> Bool {
    taskTry.rightAnswer = isAnswerRight()
    submission.addToTaskTries(taskTry)

    if currentTask + 1 < lesson.lessonTasksArray.count {
      do {
        try context.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
      currentTask += 1
      taskTry = TaskTry(context: context)
      taskTry.dictionaryBonus = lesson.lessonTasksArray[currentTask].dictionary != nil
      translatedText = ""
      showDictionary = false
      showColoredAnswer = false
      showEditor = false
      return true
    } else {
      submission.calculateScore()
      lesson.addToSubmissions(submission)
      lesson.markCompleted(context: context) //context.save()'s there
      return false
    }
  }
  

  public var stars: Int {
    if isAnswerRight() {
      if taskTry.coloredAnswerBonus {
        return 5
      } else {
        return 4
      }
    } else {
      return 0
    }
  }
  
  func isAnswerRight() -> Bool {
    let wordsFromAnswer = words(text: translatedText)
    let wordsFromTranslatedText = words(text: task.translatedText!)
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
  
  
  func answerText() -> Text {
    var text = Text("")
    if showColoredAnswer {
      let originalWordsFromAnswer = translatedText.split(separator: " ")
      let wordsFromAnswer = words(text: translatedText)
      let wordsFromTranslatedText = words(text: task.translatedText!)
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
    } else {
      text = Text(translatedText)
    }
    return text
  }
}

func words(text: String) -> [String.SubSequence] {
  let punctuations: Set<Character> = [",", ".", "!", ";", "\"", "?", "”", "“","'","`","’", "-", "—", "–"]
  var cleanText = text.uppercased()
  cleanText.removeAll(where: {punctuations.contains($0)})
  return cleanText.split(separator: " ")
}



