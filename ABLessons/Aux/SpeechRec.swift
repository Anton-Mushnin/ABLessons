//
//  SpeechRec.swift
//  SpeechToTextDemo
//
//  Created by Altynbek Usenbekov on 1/8/20.
//  Copyright © 2020 Altynbek Usenbekov. All rights reserved.
//

import Foundation
import Speech
import SwiftUI

class SpeechRec: ObservableObject {
  
  private var onFinished: ((String, Error?) -> Void)
  @Binding var showPermittionAlert: Bool

  @Published public var recognizedTextFinal = ""
  @Published private(set) var isRunning = false
  @Published private(set) var isRecognizing = false

  
  let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
  let audioSession = AVAudioSession.sharedInstance()
  let audioEngine = AVAudioEngine()
  let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
  var recognitionTask: SFSpeechRecognitionTask?
  
  init(showPermittionAlert: Binding<Bool>, onFinished: @escaping (String, Error?) -> Void) {
    self.onFinished = onFinished
    self._showPermittionAlert = showPermittionAlert
  }
    
  func start() {
    SFSpeechRecognizer.requestAuthorization { status in
      switch status {
            case .authorized: DispatchQueue.main.async {
              
              do {
                try self.startRecognition()
              } catch let error {
                print("There was a problem starting recording: \(error.localizedDescription)")
              }
                    }
            default: self.showPermittionAlert = true
      }
    }
  }
    
  func startRecognition() throws {
      recognitionRequest.shouldReportPartialResults = false;
      recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20) { //testing waiting messages

          self.isRecognizing = false
          guard error == nil, let result = result else {
            self.onFinished("", error)
            return
          }
          if result.isFinal {
            self.onFinished(result.bestTranscription.formattedString, nil)
          }
//        }  //testing waiting messages
        
      }
                    
      let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
      audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
        self.recognitionRequest.append(buffer)
      }
      
      audioEngine.prepare()
      try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
      try audioEngine.start()
      self.isRunning = true
  }
    
  func cancelTask() {
    recognitionTask?.cancel()
  }
  
  
  func stop() {
    recognitionRequest.endAudio()
    audioEngine.stop()
    audioEngine.inputNode.removeTap(onBus: 0) // Call after audio engine is stopped as it modifies the graph.
    try? audioSession.setActive(false)
    self.isRunning = false
    self.isRecognizing = true
  }
  
    
  
}
