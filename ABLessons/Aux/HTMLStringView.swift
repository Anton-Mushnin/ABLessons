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

  class Coordinator: NSObject, WKNavigationDelegate {
      var parent: HTMLStringView

      init(_ parent: HTMLStringView) {
          self.parent = parent
      }

      // Delegate methods go here
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      if navigationAction.navigationType == .linkActivated  {
        if let url = navigationAction.request.url {
          UIApplication.shared.open(url)
          decisionHandler(.cancel)
        }
      } else {
        decisionHandler(.allow)
      }
    }
  }
  
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.scrollView.showsVerticalScrollIndicator = false
    return webView
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.navigationDelegate = context.coordinator
    let htmlContentNotArial = htmlContent.replacingOccurrences(of: "font-family: Arial", with: "")
    uiView.loadHTMLString(htmlContentNotArial, baseURL: nil)
  }
}
