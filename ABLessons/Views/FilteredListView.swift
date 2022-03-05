//
//  FilteredListView.swift
//  ABLessons
//
//  Created by Антон Мушнин on 22.02.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct FilteredExcercisesListView: View {
  @Environment(\.managedObjectContext) var moc
  @FetchRequest var tasksToRepeat: FetchedResults<LessonTask>
  
  init(filter: Int) {
    _tasksToRepeat = FetchRequest<LessonTask>(entity: LessonTask.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \LessonTask.id, ascending: true)], predicate: NSPredicate(format: "lastStars = %i", filter as CVarArg))
  }
  
  var body: some View {
    ForEach(tasksToRepeat.indices, id: \.self) { i in
      NavigationLink(destination: RepeatingTasksView(viewModel: RepeatingTasksViewModel(tasks: Array(tasksToRepeat.dropFirst(i)) as [LessonTask], context: moc))) {
        Text((tasksToRepeat[i] as LessonTask).textToTranslate ?? "").lineLimit(1)
      }
    }
  }
}

struct FilteredLessonsListView: View {
  @Binding var refreshID: UUID //to refresh parent view
  @Environment(\.managedObjectContext) var moc
  @FetchRequest var lessonsToRepeat: FetchedResults<Lesson>
  
  init(filter: Int, refreshID: Binding<UUID>) {
    _lessonsToRepeat = FetchRequest<Lesson>(entity: Lesson.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Lesson.id, ascending: true)], predicate: NSPredicate(format: "minStars = %i", filter as CVarArg))
    self._refreshID = refreshID
  }
  
  var body: some View {
    ForEach(lessonsToRepeat, id: \.self) { lesson in
      NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))
                      .onDisappear(perform: {
                                    withAnimation {
                                      self.refreshID = UUID()
                                    }
                      })){
        Text(lesson.title ?? "")
      }
    }
  }
}



