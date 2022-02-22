//
//  LessonTask+CoreDataProperties.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//
//

import Foundation
import CoreData


extension LessonTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LessonTask> {
        return NSFetchRequest<LessonTask>(entityName: "LessonTask")
    }

    @NSManaged public var dictionary: String?
    @NSManaged public var id: NSUUID
    @NSManaged public var order: Int16
    @NSManaged public var textToTranslate: String?
    @NSManaged public var translatedText: String?
    @NSManaged public var fromLesson: Lesson?
    @NSManaged public var tries: NSSet?
    @NSManaged public var lastStars: Int16

}

// MARK: Generated accessors for tries
extension LessonTask {

    @objc(addTriesObject:)
    @NSManaged public func addToTries(_ value: TaskTry)

    @objc(removeTriesObject:)
    @NSManaged public func removeFromTries(_ value: TaskTry)

    @objc(addTries:)
    @NSManaged public func addToTries(_ values: NSSet)

    @objc(removeTries:)
    @NSManaged public func removeFromTries(_ values: NSSet)

}

extension LessonTask : Identifiable {

}
