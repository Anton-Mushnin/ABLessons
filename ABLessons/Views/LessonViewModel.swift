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
  @Published var stage = LessonStage.text
  @Published var text: String
  @Published var currentText = 0
  private var currentTask = 0
  @Published var task: LessonTask?
  @Published var taskTry: TaskTry
  @Published var numberOfPages: Int
  @Published var toolbarButtonCaption = ""
  public var submissions: [LessonSubmission]
  private var submission: LessonSubmission

  
  class func prepareText(text: String, isOneText: Bool) -> String {
    let preparedText = "<div style = \"font-size: 55px\">" + text.replacingOccurrences(of: "font-family: Arial", with: "") + "</div><br><br>" + (!isOneText ? "<br><br><br><br>" : "")
    return preparedText
  }
  
  
  init(lesson: Lesson, context: NSManagedObjectContext) {
    self.context = context
    self.lesson = lesson
    text = LessonViewModel.prepareText(text: lesson.lessonTextsArray[0].text ?? "", isOneText: lesson.lessonTextsArray.count < 2)
    
    submissions = lesson.lessonSubmissionsArray
    
    if let lastSubmission = lesson.lessonSubmissionsArray.last, lastSubmission.taskTriesArray.count < lesson.lessonTasksArray.count {
      submission = lastSubmission
      currentTask = lastSubmission.taskTriesArray.count
      stage = .task
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
  }
  
  
  func next() {
    if stage == .text {
      if self.lesson.lessonTextsArray.count > currentText + 1 {
        currentText += 1
        text = LessonViewModel.prepareText(text: self.lesson.lessonTextsArray[currentText].text ?? "", isOneText: false)
      } else {
        if task != nil {
          self.stage = .task
        }
      }
    }
    setToolbarCaption()
  }
  
  func nextTask() {
    taskTry.rightAnswer = task!.isAnswerRight(taskTry: taskTry)
    submission.addToTaskTries(taskTry)
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
      taskTry.dictionaryBonus = lesson.lessonTasksArray[currentTask].dictionary != nil
    } else {
      submission.calculateScore()
      lesson.markCompleted(context: context) //context.save()'s there
      submissions = lesson.lessonSubmissionsArray
      stage = .score
    }
    setToolbarCaption()
  }
  
  func previous() {
    switch stage {
    case .text:
      if currentText > 0 {
        currentText = currentText - 1
        text = LessonViewModel.prepareText(text: self.lesson.lessonTextsArray[currentText].text ?? "", isOneText: false)
      }
    case .task:
      stage = .text
    case .score:
      break
    }
    setToolbarCaption()
  }
  
  
  //returns false when view should be dismissed. Called in the .text stage only
  func toolbarButtonPressed() -> Bool {
    if task != nil {
      stage = .task
      return true
    } else {
      lesson.markCompleted(context: context)
      return false
    }
  }
  
  
  func setToolbarCaption() {
    switch stage {
    case .text:
      if lesson.lessonTextsArray.count == currentText + 1 {
        toolbarButtonCaption = lesson.lessonTasksArray.count > 0 ? "Excersise" : "Done"
      } else {
        toolbarButtonCaption = ""
      }
    case .task:
      toolbarButtonCaption = "\(currentTask + 1) / \(lesson.lessonTasksArray.count)"
    case .score:
      break
    }
  }
  
}
