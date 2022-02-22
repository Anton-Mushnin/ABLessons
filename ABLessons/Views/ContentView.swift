//
//  ContentView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @State var maxStars = 3
  @State var starsForExcercises = 1
  @Environment(\.managedObjectContext) var moc
  @FetchRequest(entity: Course.entity(), sortDescriptors: [
    NSSortDescriptor(keyPath: \Course.lastAccessDate, ascending: false)]) var courses: FetchedResults<Course>
  @FetchRequest(entity: Lesson.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Lesson.dueDate, ascending: true)], predicate: NSPredicate(format: "dueDate < %@", Date() as CVarArg)) var dueLessons: FetchedResults<Lesson>
//   @FetchRequest(entity: LessonTask.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \LessonTask.id, ascending: true)], predicate: NSPredicate(format: "lastStars = %i", maxStars as CVarArg)) var tasksToRepeat1: FetchedResults<LessonTask>
//  @FetchRequest var tasksToRepeat : FetchedResults<LessonTask>
//  @State var tasksToRepeat = [LessonTask]()
  @State var lessonsToRepeat = [Lesson]()
  @State var starsForLessons = 1
//  @State var starsForExcercises = 1//: Int
  
  
  init() {
    //starsForExcercises = 1
    
    //Intialize the FetchRequest property wrapper
 //   _tasksToRepeat = FetchRequest(entity: LessonTask.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \LessonTask.id, ascending: true)], predicate: NSPredicate(format: "lastStars = %i", starsForExcercises as CVarArg))
  }

  
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
                  NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))){ //LazyView(LessonTextView(lesson: lesson))) {
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
//            VStack {
 //             Text("Отбор по оценкам")
//              HStack { Text("оценка < ")
//              ZStack {
//                HStack {
//                  ForEach(1...5, id: \.self) { index in
//                    Image(systemName: "star").onTapGesture {
//                      stars = index
//                      fetchExcersizesWithMark(mark: stars)
//                    }.foregroundColor(.yellow)
//                  }
//                }
//                HStack {
//                  if (stars > 0) {
//                    ForEach(1...stars, id: \.self) { index in
//                      Image(systemName: "star.fill").onTapGesture {
//                        stars = index
//                        fetchExcersizesWithMark(mark: stars)
//                      }.foregroundColor(.yellow)
//                    }
//                  }
//                  if stars < 5 {
//                    ForEach((stars + 1)...5, id: \.self) { _ in
//                      Image(systemName: "star.fill")
//                        .opacity(0)
//                    }
//                  }
//                }
//              }
//              }
//            }
  //          Section(header: Text("Отбор по оценкам")) {

              Section(header:
                HStack { Text("Уроки с оценкой ")
                  ZStack {
                    HStack {
                      ForEach(1...5, id: \.self) { index in
                        Image(systemName: "star").onTapGesture {
                          starsForLessons = index
                          fetchLessonsWithMark(mark: starsForLessons)
                        }.foregroundColor(.yellow)
                      }
                    }
                    HStack {
                      if (starsForLessons > 0) {
                        ForEach(1...starsForLessons, id: \.self) { index in
                          Image(systemName: "star.fill").onTapGesture {
                            starsForLessons = index
                            fetchLessonsWithMark(mark: starsForLessons)
                          }.foregroundColor(.yellow)
                        }
                      }
                      if starsForLessons < 5 {
                        ForEach((starsForLessons + 1)...5, id: \.self) { _ in
                          Image(systemName: "star.fill")
                            .opacity(0)
                        }
                      }
                    }
                  }
                  }) {
//                ForEach(lessonsToRepeat, id: \.self) { lesson in
//                  NavigationLink(destination: LessonView(viewModel: LessonViewModel(lesson: lesson, context: moc))){
//                    Text(lesson.title ?? "")
//                  }
//                }
                FilteredLessonsListView(filter: starsForLessons)
              }
            Section(header:
              HStack { Text("Упражнения с оценкой ")
                ZStack {
                  HStack {
                    ForEach(1...5, id: \.self) { index in
                      Image(systemName: "star").onTapGesture {
                        starsForExcercises = index
         //               fetchExcercisesWithMark(mark: starsForExcercises)
                      }.foregroundColor(.yellow)
                    }
                  }
                  HStack {
                    if (starsForExcercises > 0) {
                      ForEach(1...starsForExcercises, id: \.self) { index in
                        Image(systemName: "star.fill").onTapGesture {
                          starsForExcercises = index
         //                 fetchExcercisesWithMark(mark: starsForExcercises)
                        }.foregroundColor(.yellow)
                      }
                    }
                    if starsForExcercises < 5 {
                      ForEach((starsForExcercises + 1)...5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                          .opacity(0)
                      }
                    }
                  }
                }
                })  {
              FilteredExcercisesListView(filter: starsForExcercises)
       //         ForEach(tasksToRepeat, id: \.self) { task in
       //           Text(task.textToTranslate ?? "")
       //         }
              }
 //           }
//            if tasksToRepeat.count > 0 {
//              Section(header: Text("Упражнения с 3 звездами")) {
//                ForEach(tasksToRepeat) { (task: LessonTask) in
//                  Text(" \(task.textToTranslate ?? "") ")// ?? "")
//                }
//              }
//            }
          }.background(Color.foregroundColor.ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
      }.onAppear() {
        showLoad = false
   //     fetchExcercisesWithMark(mark: starsForExcercises)
        fetchLessonsWithMark(mark: starsForLessons)
        }
    }
  
  func delete(at offsets: IndexSet) {
    offsets.forEach { index in
      let course = self.courses[index]
      self.moc.delete(course)
    }
    saveContext()
  }
  
  func starImage(systemName: String) -> some View {
    return Image(systemName: systemName)
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 30, height: 30)
    .foregroundColor(.yellow)
  }
  
  
//  func fetchExcercisesWithMark(mark: Int) {
//    print("fetching")
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LessonTask")
//    fetchRequest.includesSubentities = false
//    fetchRequest.predicate = NSPredicate(format: "lastStars = %i", mark as CVarArg)
//    do {
//      let fetchedObjects  = try moc.fetch(fetchRequest) as! [LessonTask]
//        tasksToRepeat = fetchedObjects
//    }
//
//    catch {
//        print("error executing fetch request: \(error)")
//    }
//  }
  
  func fetchLessonsWithMark(mark: Int) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lesson")
    fetchRequest.includesSubentities = false
    fetchRequest.predicate = NSPredicate(format: "minStars = %i", mark as CVarArg)
    do {
      let fetchedObjects  = try moc.fetch(fetchRequest) as! [Lesson]
        lessonsToRepeat = fetchedObjects
    }
    catch {
        print("error executing fetch request: \(error)")
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
