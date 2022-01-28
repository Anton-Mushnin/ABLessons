//
//  HTMLStringView.swift
//  ABLessons
//
//  Copyright © 2021 Антон Мушнин. All rights reserved.
//

import Foundation
import WebKit
import SwiftUI



struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
  
    func makeUIView(context: Context) -> WKWebView {
      let webView = WKWebView()
      webView.scrollView.showsVerticalScrollIndicator = false
      return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let htmlContentNotArial = htmlContent.replacingOccurrences(of: "font-family: Arial", with: "")
        uiView.loadHTMLString(htmlContentNotArial, baseURL: nil)
    }
}
