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
  private static let htmlViewStyle = "<div style = \"font-size: 55px\">" //temp. need to adjust for different screens
  @State var schoolLink = ""
  
  var isLastText: Bool {
    return (lesson.lessonTextsArray.count - 1) == textIndex
  }
  

  var body: some View {
    ZStack {
      HTMLStringView(htmlContent: LessonTextView.htmlViewStyle + lesson.lessonTextsArray[textIndex].text! + schoolLink + "</div>" + "<br><br><br><br><br><br>" )
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


        VStack {
          Spacer()
          if lesson.lessonTextsArray.count > 1 {
            VisualEffectView(effect: UIBlurEffect(style: .extraLight))
              .frame(height: 40)
          }
        }
        
        
        VStack {
          Spacer()
          if lesson.lessonTextsArray.count > 1 {
              PageControlView(numberOfPages: lesson.lessonTextsArray.count, currentPage: $textIndex)
                .padding(15)
          }
        }
    
      
    }.onAppear() {
        self.goToTask = false
      }
  }
}

 







