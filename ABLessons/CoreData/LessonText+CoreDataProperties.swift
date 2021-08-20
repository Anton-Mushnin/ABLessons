//
//  LessonText+CoreDataProperties.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//
//

import Foundation
import CoreData


extension LessonText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LessonText> {
        return NSFetchRequest<LessonText>(entityName: "LessonText")
    }

    @NSManaged public var order: Int16
    @NSManaged public var text: String?
    @NSManaged public var fromLesson: Lesson?

}

extension LessonText : Identifiable {

}
