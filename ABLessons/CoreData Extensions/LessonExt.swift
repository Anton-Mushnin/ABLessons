//
//  LessonExt.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import CoreData


extension Lesson {
  
  static var dueLessonsFetchRequest: NSFetchRequest<Lesson> {
    let request: NSFetchRequest<Lesson> = Lesson.fetchRequest()
    request.predicate = NSPredicate(format: "dueDate < %@", Date() as CVarArg)
    request.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]

    return request
  }
  
  
  
  func markCompleted(context: NSManagedObjectContext) {
    completed = true
    if !isPassedOnce {
      dueDate = Date().addingTimeInterval(60 * 60 * 24 * 3)
      isPassedOnce = true
    } else {
      if !isPassedTwice {
        dueDate = Date().addingTimeInterval(60 * 60 * 24 * 7)
        isPassedTwice = true
      } else {
        dueDate = nil
      }
    }
    
    do {
      try context.save()
    } catch {
      print("Error saving managed object context: \(error)")
    }  
  }
  

  
  public var wrappedTitle: String {
    title ?? "Unknown lesson"
  }
  
  public var wrappedID: String {
    id ?? "no id"
  }
    
  
  public var lessonTextsArray: [LessonText] {
    let set = texts as? Set<LessonText> ?? []
    return set.sorted {
      $0.order < $1.order }
  }
  
  public var lessonTasksArray: [LessonTask] {
    let set = tasks as? Set<LessonTask> ?? []
    return set.sorted {
      $0.order < $1.order }
  }
  
  public var lessonSubmissionsArray: [LessonSubmission] {
    let set = submissions as? Set<LessonSubmission> ?? []
    return set.sorted {
      $0.date! < $1.date!
    }
  }
}
