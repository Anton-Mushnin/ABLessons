//
//  LessonSubmission+CoreDataProperties.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//
//

import Foundation
import CoreData


extension LessonSubmission {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LessonSubmission> {
        return NSFetchRequest<LessonSubmission>(entityName: "LessonSubmission")
    }

    @NSManaged public var date: Date?
    @NSManaged public var score: Double
    @NSManaged public var submissionNumber: Int16
    @NSManaged public var fromLesson: Lesson?
    @NSManaged public var taskTries: NSSet?

}

// MARK: Generated accessors for taskTries
extension LessonSubmission {

    @objc(addTaskTriesObject:)
    @NSManaged public func addToTaskTries(_ value: TaskTry)

    @objc(removeTaskTriesObject:)
    @NSManaged public func removeFromTaskTries(_ value: TaskTry)

    @objc(addTaskTries:)
    @NSManaged public func addToTaskTries(_ values: NSSet)

    @objc(removeTaskTries:)
    @NSManaged public func removeFromTaskTries(_ values: NSSet)

}

extension LessonSubmission : Identifiable {

}
