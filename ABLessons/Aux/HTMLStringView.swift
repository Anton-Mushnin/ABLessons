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

  class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
    var parent: HTMLStringView
    var lastScrollPosition = CGPoint(x: 0,y: 0)
    var currentScrollViewContentSize = CGSize(width: 0, height: 0)

    init(_ parent: HTMLStringView) {
        self.parent = parent
    }
    
    // Delegate methods go here
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      //since we scrolled manualy it's not a new page anymore. updateUIView and didFinishNavigate can't do it in time
      currentScrollViewContentSize = scrollView.contentSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      //if view is trying to scroll to top (after disappear) && this is not a new page - should return to saved position
      if scrollView.contentOffset.y == 0 && lastScrollPosition.y > 0 && scrollView.contentSize == currentScrollViewContentSize {
        scrollView.setContentOffset(lastScrollPosition, animated: false)
      } else {
        lastScrollPosition = scrollView.contentOffset
      }
        
     }

    //to open links in safari
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
    webView.navigationDelegate = context.coordinator
    webView.scrollView.delegate = context.coordinator
    return webView
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(htmlContent, baseURL: nil)
  }
}
