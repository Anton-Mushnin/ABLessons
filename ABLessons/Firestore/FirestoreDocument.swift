//
//  FirestoreDocument.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift


class FirestoreDocument: Codable, Identifiable {
  @DocumentID var id: String?
  var title: String
  var order: Int16?
}

