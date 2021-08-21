//
//  LessonsList.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI
import CoreData

struct LessonsListView: View {
  @ObservedObject var viewModel: LessonsListViewModel
  var body: some View {
    List {
      Section(header: Text(viewModel.course.wrappedTitle)) {
        ForEach(viewModel.dueLessons) { lesson in
          LessonListRow(lesson: lesson)
        }
      }
      if !viewModel.completedLessons.isEmpty {
        Section(header: Text("пройдено:").font(.body)) {
          ForEach(viewModel.completedLessons) { lesson in
            LessonListRow(lesson: lesson)
          }
        }
      }
    }
    .onAppear {
      viewModel.updateList()
      }
  }
}


struct LessonListRow: View {
  var lesson: Lesson
  var body: some View {
      NavigationLink(destination: LessonTextView(lesson: lesson)) {
        Text(lesson.title!).font(.callout)
      }
      .isDetailLink(true)
      .disabled(lesson.texts!.count == 0)
  }
}

