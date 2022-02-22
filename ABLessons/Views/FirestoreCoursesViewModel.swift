//
//  FirestoreCourses.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import CoreData


class FirestoreCoursesViewModel: ObservableObject {
  private var moc: NSManagedObjectContext
  private var db: Firestore
  
  private let collectionNames = ["authors", "courses", "lessons"] //для обращения к Firestore
  private let collectionCaptions = ["Авторы", "Курсы", "Занятия"] //Для подписей
  
  @Published var collection = [FirestoreDocument]()
  @Published var isDataLoading = false
  @Published var success = false
  private var lessons = [FirestoreDocument]()
 
  private var level = 0
  private var path = "authors"
  private var titles = [String: String]()
  private var IDs = [String: String]()
  private var userId: String = "unknown"
  
  
  var caption: String {
    if isLastLevel {
      return "Уроки в этом курсе:"
    }
    if level > 0, let title = titles[collectionNames[level - 1]] {
      return title
    }
    return collectionCaptions[0]
  }
  
  
  var isLastLevel: Bool {
    collectionNames.count - 1 == level
  }
  
  var isNextLevelLast: Bool {
    collectionNames.count - 2 == level
  }
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
    db = Firestore.firestore()
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = true
    db.settings = settings
    goToRoot()
  }
  
  private func goToRoot() {
    success = false
    level = 0
    path = "authors"
    titles = [String: String]()
    IDs = [String: String]()
    loadDocs()
  }
  
  
  public func nextLevel(docID: String, title: String) {
    if level < collectionNames.count - 1 {
      collection.removeAll()
      titles[collectionNames[level]] = title
      IDs[collectionNames[level]] = docID
      level += 1
      path = path + "/" + docID + "/" + collectionNames[level]
      loadDocs()
    }
  }
  
  public func prevLevel() -> Bool {
    if level == 0 {
      return false
    }
    collection.removeAll()
    path = String(path.prefix(upTo: path.lastIndex(of: "/")!))
    path = String(path.prefix(upTo: path.lastIndex(of: "/")!))
    titles[collectionNames[level - 1]] = nil
    IDs[collectionNames[level - 1]] = nil

    loadDocs()
    level = level - 1
    return true

  }
  
  
  private func loadDocs() {
    var loadingFinished = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      if !loadingFinished {
        self.isDataLoading = true
      }
    }
    db.collection(path).getDocuments { (querySnapshot, error) in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }
      
      if let querySnapshot = querySnapshot {
        withAnimation {
          self.collection = querySnapshot.documents.compactMap { document -> FirestoreDocument? in
            try? document.data(as: FirestoreDocument.self)
          }
        }
      }
      loadingFinished = true
      self.isDataLoading = false
    }
  }
  
  
  private func getAuthor(course: Course) -> Author {
    if let authorFromCD = getCoreDataObjectForID(forID: IDs["authors"]!, entityName: "Author") as? Author {
      return authorFromCD
    }
    let author = Author(context: moc)
    let docRef = db.collection("authors").document(IDs["authors"]!)
    docRef.getDocument { (document, error) in
      if let document = document, document.exists {
        author.id = self.IDs["authors"]!
        author.imageURL = document.data()!["imageURL"] as? String
        author.name = document.data()!["title"] as? String
        if let homepage = document.data()!["homepage"] as? String {
          author.homepage = homepage
        }
        getImageFromWeb(author.imageURL ?? "") { (image) in
          if let image = image {
            author.image = image
            course.lastAccessDate = Date()
            self.saveContext()
          }
        }
      } else {
          print("Document does not exist")
      }
    }
    return author
  }
  
  private func getCourse() -> Course {
    let courseID = IDs["courses"]!
    if let courseFromCD = getCoreDataObjectForID(forID: courseID, entityName: "Course") as? Course {
      return courseFromCD
    }
    let course = Course(context: moc)
    course.id = courseID
    if let courseTitle = titles["courses"]  {
      course.title = courseTitle
    }
    return course
  }
  
  
  
  public func loadCourse() {
    var loadingFinished = false
    var fsLessons = [FSLesson]()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      if !loadingFinished {
        self.isDataLoading = true
      }
    }
    let course = getCourse()
    let author = getAuthor(course: course)
    author.addToCourses(course)
    
    if collection.count == 0 {
      self.saveContext()
      withAnimation {
        success = true
        isDataLoading = false
      }
    }
    //the function called on the last level only so it's assumed path is for lessons
    db.collection(path).getDocuments { [unowned self] (querySnapshot, error) in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }
      if let querySnapshot = querySnapshot {
          fsLessons = querySnapshot.documents.compactMap { document -> FSLesson? in
            try? document.data(as: FSLesson.self)
          }
        for (fsLesson) in fsLessons {
          
//          let newPath = "/authors/WrPCZrHHo1VgTEvJxfwO/courses/0swJI50shPuXmjSWEntw/lessons/"
//          do {
//            var newLesson = fsLesson
//            newLesson.order = 109 - fsLesson.order
//            _ = try db.collection(newPath).addDocument(from: newLesson)
//          } catch {
//            fatalError("Unable to add lesson: \(error.localizedDescription).")
//          }
//
          
          
          if !isLessonExists(id: fsLesson.id!) {
            let lesson = Lesson(context: moc)
            lesson.title = fsLesson.title
            lesson.id = fsLesson.id
            lesson.order = Int16(fsLesson.order)
            course.addToLessons(lesson)
            if let texts = fsLesson.texts {
              for (fsLessonText) in texts {
                let lessonText = LessonText(context: self.moc)
                lessonText.text = fsLessonText.text
                lessonText.order = Int16(fsLessonText.order)
                lesson.addToTexts(lessonText)
              }
            }
            if let tasks = fsLesson.tasks {
              for (fsLessonTask) in tasks {
                let lessonTask = LessonTask(context: self.moc)
                lessonTask.id = NSUUID()//fsLessonTask.id
                lessonTask.textToTranslate = fsLessonTask.textToTranslate
                lessonTask.translatedText = fsLessonTask.translatedText
                lessonTask.dictionary = fsLessonTask.dictionary
                lessonTask.order = Int16(fsLessonTask.order)
                if let dic = lessonTask.dictionary {
                  let replaced = dic.replacingOccurrences(of: "<br>", with: "\n")
                  lessonTask.dictionary = replaced
                }
                lesson.addToTasks(lessonTask)
              }
            }
          }
        }
        self.saveContext()
        withAnimation {
          success = true
          isDataLoading = false
          loadingFinished = true
        }
      }
    }
  }
    
  
  
  
  public func addToCoreData() {
    isDataLoading = true
    
    let course = getCourse()
    let author = getAuthor(course: course)
    author.addToCourses(course)
    
    if collection.count == 0 {
      self.saveContext()
      withAnimation {
        success = true
        isDataLoading = false
      }
    }

    for (index, fsLesson) in collection.enumerated() {
      if !isLessonExists(id: fsLesson.id!) {
        let lesson = Lesson(context: moc)
        lesson.title = fsLesson.title
        lesson.id = fsLesson.id
        lesson.order = fsLesson.order!
        course.addToLessons(lesson)
        let  lessonPath = path + "/" + fsLesson.id!
        addTextsAndTasks(path: lessonPath, lesson: lesson)
      } else {
        if index == collection.count - 1 {
          self.saveContext()
          withAnimation {
            success = true
            isDataLoading = false
          }
        }
      }
      
    }
  }
  
  
  
  
  private func getCoreDataObjectForID(forID id: String, entityName: String) -> NSManagedObject? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    fetchRequest.includesSubentities = false
    fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
    do {
      let fetchedObjects  = try moc.fetch(fetchRequest) as! [NSManagedObject]
      if fetchedObjects.count > 0 {
        return fetchedObjects[0]
      }
    }
    catch {
        print("error executing fetch request: \(error)")
    }
    return nil
  }
  
 
  private func isLessonExists(id: String) -> Bool {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lesson")
      fetchRequest.includesSubentities = false
      fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", id as CVarArg)
      var entitiesCount = 0

      do {
          entitiesCount = try moc.count(for: fetchRequest)
      }
      catch {
          print("error executing fetch request: \(error)")
      }

      return entitiesCount > 0
  }
  

  
  private func addTextsAndTasks(path: String, lesson: Lesson) {
    db.collection(path + "/texts").getDocuments { querySnapshot, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      } else {
        for document in querySnapshot!.documents {
          if let order = document.data()["order"] as? Int16,
            let text = document.data()["text"] as? String {
              let lessonText = LessonText(context: self.moc)
              lessonText.text = text
              lessonText.order = order
              lesson.addToTexts(lessonText)
          }
        }
      }
      self.addTasks(path: path + "/tasks", lesson: lesson)
    }
  }
  
  
  private func addTasks(path: String, lesson: Lesson) {
    db.collection(path).getDocuments { [self] querySnapshot, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      } else {
        for document in querySnapshot!.documents {
          if let order = document.data()["order"] as? Int16,
            let textToTranslate = document.data()["textToTranslate"] as? String,
            let translatedText = document.data()["translatedText"] as? String {
              let lessonTask = LessonTask(context: self.moc)
            //  lessonTask.id = document.documentID
              lessonTask.textToTranslate = textToTranslate
              lessonTask.translatedText = translatedText
              lessonTask.order = order
              lessonTask.dictionary = document.data()["dictionary"] as? String
              if let dic = lessonTask.dictionary {
                let replaced = dic.replacingOccurrences(of: "<br>", with: "\n")
                lessonTask.dictionary = replaced
              }
              lesson.addToTasks(lessonTask)
          }
        }
      }
      if lesson.id == collection[collection.count - 1].id {
        self.saveContext()
        withAnimation {
          success = true
          isDataLoading = false
        }
      }
    }
  }
  
  
  func saveContext() {
    do {
      try moc.save()
    } catch {
      print("Error saving managed object context: \(error)")
    }
  }

  
}


func getImageFromWeb(_ urlString: String, closure: @escaping (NSData?) -> ()) {
   guard let url = URL(string: urlString) else {
     return closure(nil)

   }
   let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
     guard error == nil else {
         print("error: \(String(describing: error))")
         return closure(nil)
     }
     guard response != nil else {
         print("no response")
         return closure(nil)
     }
     guard data != nil else {
         print("no data")
         return closure(nil)
     }
     DispatchQueue.main.async {
         closure(NSData(data: data!))
     }
   }; task.resume()
}
