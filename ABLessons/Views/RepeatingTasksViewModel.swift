//
//  RepeatingTasksViewModel.swift
//  ABLessons
//
//  Created by Антон Мушнин on 23.02.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData


class RepeatingTasksViewModel: ObservableObject {
  var tasks: [LessonTask]
  let context: NSManagedObjectContext
  private var currentTask = 0
  @Published var task: LessonTask?
  @Published var taskTry: TaskTry
  
  init(tasks: [LessonTask], context: NSManagedObjectContext) {
    self.context = context
    self.tasks = tasks
    task = tasks[0]
    taskTry = TaskTry(context: context)
  }
  
  func nextTask() -> Bool {
    taskTry.rightAnswer = task!.isAnswerRight(taskTry: taskTry)
 //   submission.addToTaskTries(taskTry)
    task!.lastStars = taskTry.selfMark

    if let lesson = task?.fromLesson {
      if let min = lesson.tasks?.min(by: {($0 as! LessonTask).lastStars < ($1 as! LessonTask).lastStars}) as! LessonTask? {
        lesson.minStars = min.lastStars
      }
    }
    
    do {
      try context.save()
    } catch {
      print("Error saving managed object context: \(error)")
    }

    if currentTask + 1 < tasks.count {
      currentTask += 1
      task = tasks[currentTask]
      taskTry = TaskTry(context: context)
      taskTry.dictionaryBonus = tasks[currentTask].dictionary != nil
      return true
    } else {
      return false
    }
  }
  
   
}
