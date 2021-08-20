//
//  Course+CoreDataProperties.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var id: String?
    @NSManaged public var lastAccessDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var lessons: NSSet?
    @NSManaged public var ofAuthor: Author?

}

// MARK: Generated accessors for lessons
extension Course {

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)

}

extension Course : Identifiable {

}
