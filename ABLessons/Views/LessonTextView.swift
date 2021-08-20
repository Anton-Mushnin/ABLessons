//
//  LessonStartFinish.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct LessonTextView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) var moc

  var lesson: Lesson
  @State private var goToTask = false
  @State private var textIndex = 0
  private static let htmlViewStyle = "<div style = \"font-size: 50px\">"
  @State var schoolLink = ""
  
  var isLastText: Bool {
    return (lesson.lessonTextsArray.count - 1) == textIndex
  }
  

  var body: some View {
    VStack (spacing: 0){
      
      NavigationLink(destination: LazyView(TaskView(viewModel: TaskViewModel(lesson: lesson, context: moc))), isActive: $goToTask) {
          EmptyView()
      }.isDetailLink(false)
       .toolbar {
          ToolbarItemGroup(placement: .navigationBarTrailing) {
            if isLastText {
              if !lesson.lessonTasksArray.isEmpty {
                Button("Упражнение") {
                  self.goToTask = true
                }
              } else {
                Button("Готово") {
                  self.lesson.markCompleted(context: moc)
                  self.presentationMode.wrappedValue.dismiss()
                }
              }
            }
          }
        }
 
      HTMLStringView(htmlContent: LessonTextView.htmlViewStyle + lesson.lessonTextsArray[textIndex].text! + schoolLink + "</div" )
          .padding(.leading, 10)
          .padding(.trailing, 10)
          .padding(.top, 5)
          .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onEnded({ value in
              if value.translation.width < 0 {
                if !isLastText {
                  if textIndex == lesson.lessonTextsArray.count - 2 {
                    schoolLink = "" //<p><a href = \"https://www.brejestovski.com\">Сайт Антона Брежестовского - автора этого урока - brejestovski.com</a>"
                  } else {
                    schoolLink = ""
                  }
                  textIndex += 1
                  
                } else {
                  if !lesson.lessonTasksArray.isEmpty {
                    self.goToTask = true
                  }
                }
              }
              if value.translation.width > 0 {
                if textIndex > 0 {
                  textIndex -= 1
                }
              }
            }))
      
      if lesson.lessonTextsArray.count > 1 {
          pageControlView(numberOfPages: lesson.lessonTextsArray.count, currentPage: $textIndex)
                    .padding()
      }
      
    }.onAppear() {
        self.goToTask = false
      }
  }
}


struct pageControlView: View {
  var numberOfPages: Int
  @Binding var currentPage: Int
  
  var body: some View {
    HStack {
      ForEach (0 ..< numberOfPages) { page in
        Image(systemName: "circle.fill")
          .resizable()
          .frame(width: 8, height: 8)
          .foregroundColor(page == currentPage ? .fontColor : .inactiveColor)
      }
    }
  }
}
 







