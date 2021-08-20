//
//  LessonsListViewModel.swift
//  ABLessons
//
//  Created by Антон Мушнин on 15.12.2020.
//  Copyright © 2020 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI


class LessonsListViewModel: ObservableObject {
  
  @Published var course: Course
  @Published var dueLessons = [Lesson]()
  @Published var completedLessons = [Lesson]()

  
  
  init(course: Course) {
    self.course = course
    filterLessons()
  }
  
  
  func updateList() {
    course.lastAccessDate = Date()
    filterLessons()
  }
  
 
  
  private func filterLessons() {
    dueLessons = []
    completedLessons = []
    
    for lesson in course.lessonsArray {
      if lesson.completed {
        completedLessons.append(lesson)
      } else {
        dueLessons.append(lesson)
      }
    }
  }

  

}
