//
//  FSLesson.swift
//  ABLessons
//
//  Created by Антон Мушнин on 31.10.2021.
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift





struct FSLesson: Codable {
  @DocumentID var id: String?
  var order = 0//: Int
  var tasksNumber = 0//: Int
  var textsNumber = 0//: Int
  var title = ""//: String
  var tasks: [FSLessonTask]?
  var texts: [FSLessonText]?
}

struct FSLessonText: Codable {
  var order = 0//: Int
  var text = ""//: String
}


struct FSLessonTask: Codable {
  var order = 0//: Int
  var dictionary: String?// = ""//: String?
  var textToTranslate = ""//: String
  var translatedText = ""//: String
  
}
