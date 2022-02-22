//
//  ContentView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI
import CoreData


struct ContentView: View {
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(entity: Course.entity(), sortDescriptors: [
    NSSortDescriptor(keyPath: \Course.lastAccessDate, ascending: false)]) var courses: FetchedResults<Course>
  @FetchRequest(entity: Lesson.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Lesson.dueDate, ascending: true)], predicate: NSPredicate(format: "dueDate < %@", Date() as CVarArg)) var dueLessons: FetchedResults<Lesson>
  @State var starsForLessons = 1
  @State var starsForExcercises = 1
  
  @State var showLoad = false
  
    var body: some View {
      NavigationView {
        VStack {
          
          NavigationLink(destination: LazyView(FirestoreCoursesView(store: FirestoreCoursesViewModel(moc: moc))), isActive: $showLoad) {
            EmptyView()
          }.navigationBarTitle(Text(""), displayMode: .inline)
           .toolbar {
             ToolbarItem(placement: .navigationBarTrailing) {
               Button(action: { showLoad = true }) {
                 Image(systemName: "folder.badge.plus")
               }
             }
           }
          
          List {
            if dueLessons.count > 0 {
              Section(header: Text("Пора повторить:")) {
                ForEach(dueLessons){ lesson in
                  NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))){
                    Text(lesson.title ?? "")
                  }
                }
              }
            }
            if courses.count > 0 {
              Section(header: Text("Курсы:")) {
                ForEach(courses) { course in
                  NavigationLink (destination: LazyView(LessonsListView(viewModel: LessonsListViewModel(course: course)))) {
                    HStack {
                      AuthorImageView(image: course.authorImage)
                      Text(course.title!).font(.callout).padding()
                    }
                  }.isDetailLink(false)
                }
                .onDelete(perform: delete)
              }
            }
            Section(header:
              HStack {
                Text("Уроки с оценкой ")
                Spacer()
                StarsEditView(stars: $starsForLessons)
                }) {
                    FilteredLessonsListView(filter: starsForLessons)
            }
            Section(header:
              HStack {
                Text("Упражнения с оценкой ")
                Spacer()
                StarsEditView(stars: $starsForExcercises)
                })  {
              FilteredExcercisesListView(filter: starsForExcercises)
            }
          }.background(Color.foregroundColor.ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
      }.onAppear() {
        showLoad = false
        }
    }
  
  func delete(at offsets: IndexSet) {
    offsets.forEach { index in
      let course = self.courses[index]
      self.moc.delete(course)
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
