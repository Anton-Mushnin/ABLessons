//
//  Lesson+CoreDataProperties.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var currentScore: Int16
    @NSManaged public var currentTasksCompleted: Int16
    @NSManaged public var currentTry: Int16
    @NSManaged public var dueDate: Date?
    @NSManaged public var firstDue: Data?
    @NSManaged public var id: String?
    @NSManaged public var isPassedOnce: Bool
    @NSManaged public var isPassedTwice: Bool
    @NSManaged public var order: Int16
    @NSManaged public var secondDue: Date?
    @NSManaged public var thirdDue: Date?
    @NSManaged public var title: String?
    @NSManaged public var fromCourse: Course?
    @NSManaged public var submissions: NSSet?
    @NSManaged public var tasks: NSSet?
    @NSManaged public var texts: NSSet?
    @NSManaged public var minStars: Int16

}

// MARK: Generated accessors for submissions
extension Lesson {

    @objc(addSubmissionsObject:)
    @NSManaged public func addToSubmissions(_ value: LessonSubmission)

    @objc(removeSubmissionsObject:)
    @NSManaged public func removeFromSubmissions(_ value: LessonSubmission)

    @objc(addSubmissions:)
    @NSManaged public func addToSubmissions(_ values: NSSet)

    @objc(removeSubmissions:)
    @NSManaged public func removeFromSubmissions(_ values: NSSet)

}

// MARK: Generated accessors for tasks
extension Lesson {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: LessonTask)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: LessonTask)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

// MARK: Generated accessors for texts
extension Lesson {

    @objc(addTextsObject:)
    @NSManaged public func addToTexts(_ value: LessonText)

    @objc(removeTextsObject:)
    @NSManaged public func removeFromTexts(_ value: LessonText)

    @objc(addTexts:)
    @NSManaged public func addToTexts(_ values: NSSet)

    @objc(removeTexts:)
    @NSManaged public func removeFromTexts(_ values: NSSet)

}

extension Lesson : Identifiable {

}
