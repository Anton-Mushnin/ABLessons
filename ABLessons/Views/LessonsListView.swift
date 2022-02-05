//
//  LessonsList.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI
import CoreData

struct LessonsListView: View {
  @Environment(\.managedObjectContext) var moc
  @ObservedObject var viewModel: LessonsListViewModel
  
  var body: some View {
    List {
      Section(header: Text(viewModel.course.wrappedTitle)) {
        ForEach(viewModel.dueLessons) { lesson in
          NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))) {
              Text(lesson.title ?? "").font(.callout)
            }
            .isDetailLink(true)
            .disabled(lesson.texts!.count == 0)
        }.onDelete(perform: deleteDueLesson)
      }
      if !viewModel.completedLessons.isEmpty {
        Section(header: Text("пройдено:").font(.body)) {
          ForEach(viewModel.completedLessons) { lesson in
            NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))) {
                Text(lesson.title ?? "").font(.callout)
              }
              .isDetailLink(true)
              .disabled(lesson.texts!.count == 0)
          }.onDelete(perform: deleteCompletedLesson)
        }
      }
    }
    .onAppear {
      viewModel.updateList()
      print("list view appear")
      }
  }
  
  
  func deleteDueLesson(at offsets: IndexSet) {
    offsets.forEach { index in
      let lesson = self.viewModel.dueLessons[index]
      self.moc.delete(lesson)
    }
    saveContext()
  }
  
  func deleteCompletedLesson(at offsets: IndexSet) {
    offsets.forEach { index in
      let lesson = self.viewModel.completedLessons[index]
      self.moc.delete(lesson)
    }
    saveContext()
  }
  
  func saveContext() {
    do {
      try moc.save()
    } catch {
      print("Error saving managed object context: \(error)")
    }
  }
  
  
  
  
}





//struct LessonListRow: View {
//  var lesson: Lesson
//  var body: some View {
//    NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))) {
//        Text(lesson.title ?? "").font(.callout)
//      }
//      .isDetailLink(true)
//      .disabled(lesson.texts!.count == 0)
//  }
//}

