//
//  CourseExt.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData


extension Course {
  
  static var coursesFetchRequest: NSFetchRequest<Course> {
    let request: NSFetchRequest<Course> = Course.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "lastAccessDate", ascending: false)]
    return request
  }
  
  
  static private func defaultDate() -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    return formatter.date(from: "2021/01/01 00:00")!

  }

  public var wrappedTitle: String {
      title ?? "Unknown Course"
  }
  
  public var wrappedAuthorName: String {
    ofAuthor?.name ?? "Unknown Author"
  }
  
  public var wrappedLastAccessDate: Date {
    lastAccessDate ?? Course.defaultDate()
  }
  
  public var lessonsArray: [Lesson] {
    let set = lessons as? Set<Lesson> ?? []
    return set.sorted {
      $0.order < $1.order
    }
  }
  
  
  public var authorImage: UIImage? {
    if let imageData = ofAuthor?.image {
      return UIImage(data: imageData as Data)
    }
    return nil
  }
  
  
}
