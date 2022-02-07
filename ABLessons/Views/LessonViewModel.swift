//
//  LessonViewModel.swift
//  ABLessons
//
//  Created by Антон Мушнин on 28.01.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

enum LessonStage {
  case text
  case task
  case score
}




class LessonViewModel: ObservableObject {

  var lesson: Lesson
  let context: NSManagedObjectContext
 // @Environment(\.managedObjectContext) var moc
  @Published var stage = LessonStage.text
  @Published var text: String
//  @Published var textToTranslate: String
  @Published var currentText = 0
  private var currentTask = 0
  @Published var task: LessonTask?
  @Published var taskTry: TaskTry
  @Published var numberOfPages: Int
  @Published var toolbarButtonCaption = ""
  public var submissions: [LessonSubmission]
  private var submission: LessonSubmission

  
  class func prepareText(text: String) -> String {
    let preparedText = "<div style = \"font-size: 55px\">" + text.replacingOccurrences(of: "font-family: Arial", with: "") + "</div>" + "<br><br><br><br><br><br>"
    return preparedText
  }
  
  
  
  
  
  
  init(lesson: Lesson, context: NSManagedObjectContext) {
    self.context = context
    self.lesson = lesson
    text = LessonViewModel.prepareText(text: lesson.lessonTextsArray[0].text ?? "")
    submissions = lesson.lessonSubmissionsArray
    
    if let lastSubmission = lesson.lessonSubmissionsArray.last, lastSubmission.taskTriesArray.count < lesson.lessonTasksArray.count {
        submission = lastSubmission
        currentTask = lastSubmission.taskTriesArray.count
    } else {
      submission = LessonSubmission(context: context)
    }
    submission.date = Date()
    if !lesson.lessonTasksArray.isEmpty {
      task = lesson.lessonTasksArray[currentTask]
    }
    
    taskTry = TaskTry(context: context)
    numberOfPages = lesson.lessonTextsArray.count
    if lesson.lessonTextsArray.count == 1 {
      toolbarButtonCaption = lesson.lessonTasksArray.count > 0 ? "Excersise" : "Done"
    }

 //   textToTranslate = lesson.lessonTasksArray[0].textToTranslate ?? ""
  }
  
  
  func next() {
    
    if stage == .text {
      if self.lesson.lessonTextsArray.count > currentText + 1 {
        currentText += 1
        text = LessonViewModel.prepareText(text: self.lesson.lessonTextsArray[currentText].text ?? "")

      } else {
        if task != nil {
          self.stage = .task
        } else {
          lesson.markCompleted(context: context)
        }
      }
    }
//    switch stage {
//    case .text:
//      if self.lesson.lessonTextsArray.count > currentText + 1 {
//        currentText += 1
//        text = LessonViewModel.prepareText(text: self.lesson.lessonTextsArray[currentText].text ?? "")
//
//      } else {
//        if task != nil {
//          self.stage = .task
//        }
//      }
//    case .task:
//      //nextTask()
//      break
//    case .score:
//      print("Error - next on the score stage")
//    }
    setToolbarCaption()

  }
  
  func nextTask() {
//    if lesson.lessonTasksArray.count > currentTask + 1 {
//      currentTask += 1
//      task = lesson.lessonTasksArray[currentTask]
//    } else {
//      stage = .score
//    }
    taskTry.rightAnswer = task!.isAnswerRight(taskTry: taskTry) //!.isAnswerRight(taskTry: taskTry)
    submission.addToTaskTries(taskTry)
  //  print(taskTry.selfMark)
    if currentTask == 0 {
      lesson.addToSubmissions(submission)
    }
    if currentTask + 1 < lesson.lessonTasksArray.count {
      do {
        try context.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
      currentTask += 1
      
      task = lesson.lessonTasksArray[currentTask]
      taskTry = TaskTry(context: context)
  //    taskTry.dictionaryBonus = lesson.lessonTasksArray[currentTask].dictionary != nil
  //    translatedText = ""
  //    showDictionary = false
  //    showColoredAnswer = false
  //    showEditor = false
  //    return true
    } else {
      submission.calculateScore()
      lesson.markCompleted(context: context) //context.save()'s there
      submissions = lesson.lessonSubmissionsArray
      stage = .score
  //    return false
    }
    setToolbarCaption()
    
    
    
    
    
  }
  
  func previous() {
    switch stage {
    case .text:
      if currentText > 0 {
        currentText = currentText - 1
        text = LessonViewModel.prepareText(text: self.lesson.lessonTextsArray[currentText].text ?? "")
      }
    case .task:
      stage = .text
    case .score:
      break
    }
    setToolbarCaption()

  }
  
  func toolbarButtonPressed() -> Bool {
    next()
    return toolbarButtonCaption != "Done"    
  }
  
  
  func setToolbarCaption() {
    if stage == .text {
      if lesson.lessonTextsArray.count == currentText + 1 {
        toolbarButtonCaption = lesson.lessonTasksArray.count > 0 ? "Excersise" : "Done"
      } else {
        toolbarButtonCaption = ""
      }
    }
    if stage == .task {
      toolbarButtonCaption = "\(currentTask + 1)/\(lesson.lessonTasksArray.count)"
    }
    if stage == .score {
      toolbarButtonCaption = "Done"
    }
    
  }
  
  

  
}
