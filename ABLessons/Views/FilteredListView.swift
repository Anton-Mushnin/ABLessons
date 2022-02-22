//
//  FilteredListView.swift
//  ABLessons
//
//  Created by Антон Мушнин on 22.02.2022.
//  Copyright © 2022 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct FilteredExcercisesListView: View {
 // @State var filter: Int
  
  @FetchRequest var tasksToRepeat: FetchedResults<LessonTask>
  init(filter: Int) {
    _tasksToRepeat = FetchRequest<LessonTask>(entity: LessonTask.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \LessonTask.id, ascending: true)], predicate: NSPredicate(format: "lastStars = %i", filter as CVarArg))
  }
  
  
    var body: some View {
      ForEach(tasksToRepeat, id: \.self) { task in
        Text((task as LessonTask).textToTranslate ?? "")
      }
    }
}

struct FilteredLessonsListView: View {
  @Environment(\.managedObjectContext) var moc

 // @State var filter: Int
  @FetchRequest var lessonsToRepeat: FetchedResults<Lesson>
  init(filter: Int) {
    _lessonsToRepeat = FetchRequest<Lesson>(entity: Lesson.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Lesson.id, ascending: true)], predicate: NSPredicate(format: "minStars = %i", filter as CVarArg))
  }
  
  
    var body: some View {
      ForEach(lessonsToRepeat, id: \.self) { lesson in
        NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))){
          Text(lesson.title ?? "")
        }
      }
    }
}






//struct FilteredListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredListView()
//    }
//}