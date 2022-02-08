//
//  TaskViewModel.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData



class TaskViewModel: ObservableObject {
  @Published var showDictionary = false
  @Published var showColoredAnswer = false
  @Published var showEditor = false
  @Published var isAnswerReady = false
  
  func newTask() {
    showDictionary = false
    showColoredAnswer = false
    showEditor = false
    isAnswerReady = false
  }
  
}




