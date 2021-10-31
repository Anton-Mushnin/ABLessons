//
//  FirestoreCoursesView.swift
//  ABLessons
//
//  Copyright © 2020 Антон Мушнин. All rights reserved.
//

import SwiftUI

struct FirestoreCoursesView: View {
  @StateObject var store: FirestoreCoursesViewModel
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    ZStack {
      Color(.foregroundColor) //фон успешной загрузки
      VStack (alignment: .leading){
        if !store.success {
          List {
            Section(header: Text(store.caption).font(.footnote).foregroundColor(.white).bold()) {
              ForEach(store.collection) { doc in
                if !store.isLastLevel {
                  Button(action: {
                        self.store.nextLevel(docID: doc.id!, title: doc.title)
                  }) {
                        Text(doc.title)
                          .foregroundColor(.black)
                  }
                } else {
                  Text("- " + doc.title)
                    .foregroundColor(.white)
                }
              }.listRowBackground(store.isLastLevel ? Color.foregroundColor : Color.white)
            }
          }.listStyle(InsetGroupedListStyle())
        }
      }.toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          if store.isLastLevel {
            Button(action: {
              //self.store.addToCoreData()
              self.store.loadCourse()
            }) {
              Image(systemName: "tray.and.arrow.down")
            }
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: {
              if !self.store.prevLevel() {
                self.presentationMode.wrappedValue.dismiss()
              }
          }) {
          Image(systemName: "chevron.left")
          }
        }
      }.navigationBarBackButtonHidden(true)
      
      if store.isDataLoading {
        ProgressView()
      }
      
      if store.success {
        Image(systemName: "checkmark.circle")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 100, height: 100)
          .foregroundColor(.gold)
          .transition(.scale)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
      }
      
    } //ZStack
  }
}

