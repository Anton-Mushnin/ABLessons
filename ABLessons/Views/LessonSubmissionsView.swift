//
//  LessonSubmissionsView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct LessonSubmissionsView: View {
  
  @Environment(\.presentationMode) var presentationMode
  var submissions: [LessonSubmission]
  
    var body: some View {
      VStack(spacing: 5) {
        List {
          ForEach(submissions, id: \.date) { submission in
            HStack {
              Text(dateToString(date: submission.date!))
              Spacer()
              Text(String(submission.score) + "%")
            }.listRowBackground(LinearGradient(gradient: Gradient(colors: [.white,  scoreToColor(score: submission.score)]), startPoint: .leading, endPoint: .trailing))
          }
        }.listStyle(InsetGroupedListStyle())
        .navigationBarBackButtonHidden(true)
        Spacer()
        Group {
          Text("Школа Антона Брежестовского").fontWeight(.bold).foregroundColor(.fontColor).padding(.top, 25)
          Text("эффективно и весело")
          Text("\(Image(systemName: "arrow.down"))")
        }.foregroundColor(.foregroundColor).padding(.leading, 25).padding(.trailing, 25)
          Button("https://www.brejestovski.com") {
          if let url = URL(string: "https://www.brejestovski.com") {
            UIApplication.shared.open(url)
          }
          }.foregroundColor(.green).padding(.bottom, 25).padding(.top, 5)
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

