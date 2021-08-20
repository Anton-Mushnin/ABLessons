//
//  LessonSubmissionsView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct LessonSubmissionsView: View {
  
  var lesson: Lesson
  @Environment(\.presentationMode) var presentationMode
  
    var body: some View {
      List {
        ForEach(lesson.lessonSubmissionsArray, id: \.date) { submission in
          HStack {
            Text(dateToString(date: submission.date!))
            Spacer()
            Text(String(submission.score) + "%")
          }.listRowBackground(LinearGradient(gradient: Gradient(colors: [.white,  scoreToColor(score: submission.score)]), startPoint: .leading, endPoint: .trailing))
        }
      }.listStyle(InsetGroupedListStyle())
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done",  action: {
            self.presentationMode.wrappedValue.dismiss()
        })
        }
      }
    }
  
  private func scoreToColor(score: Double) -> Color {
    
    if score == 0 { return .white }
    let blue = 0.93 - (score - 40) / 70 * 0.5
    return Color(red: 1, green: 0.83, blue: blue)
  }
  
  private func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    if calendar.component(.year, from: date) == calendar.component(.year, from: Date()) {
      formatter.dateFormat = "MMMM dd"
    } else {
      formatter.dateFormat = "MMMM dd, yyyy"
    }
    return formatter.string(from: date)
  }
  
}

