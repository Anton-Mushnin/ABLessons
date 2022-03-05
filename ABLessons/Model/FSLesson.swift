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
  var order = 0
  var title = ""
  var tasks: [FSLessonTask]?
  var texts: [FSLessonText]?
}

struct FSLessonText: Codable {
  var order = 0
  var text = ""
}


struct FSLessonTask: Codable {
  var order = 0
  var dictionary: String?
  var textToTranslate = ""
  var translatedText = ""
  
}
