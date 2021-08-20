//
//  TaskTry+CoreDataProperties.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskTry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskTry> {
        return NSFetchRequest<TaskTry>(entityName: "TaskTry")
    }

    @NSManaged public var coloredAnswerBonus: Bool
    @NSManaged public var date: Date?
    @NSManaged public var dictationBonus: Bool
    @NSManaged public var dictionaryBonus: Bool
    @NSManaged public var rightAnswer: Bool
    @NSManaged public var translatedText: String?
    @NSManaged public var selfMark: Int16
    @NSManaged public var fromSubmission: LessonSubmission?
    @NSManaged public var fromTask: LessonTask?

}

extension TaskTry : Identifiable {

}
