//
//  Author+CoreDataProperties.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }
    @NSManaged public var id: String?
    @NSManaged public var homepage: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var courses: NSSet?

}

// MARK: Generated accessors for courses
extension Author {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}

extension Author : Identifiable {

}
