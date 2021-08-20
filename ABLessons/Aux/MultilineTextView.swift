//https://gist.github.com/prafullakumar/b63f93219c29bde20250d5178ad62259#file-multilinetextviewswiftui-swift

import SwiftUI


struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?
    @State private var viewHeight: CGFloat = 1
    @State private var shouldShowPlaceholder = false
    @Binding private var text: String
    
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.shouldShowPlaceholder = $0.isEmpty
        }
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $viewHeight, onDone: onCommit)
          .frame(minHeight: viewHeight, maxHeight: .infinity)
    }

    var placeholderView: some View {
        Group {
            if shouldShowPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
    
    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

}


private struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var isFirstResponderMy = false
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        textField.layer.borderColor = UIColor.placeholderText.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        textField.autocorrectionType = .no
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
            uiView.text = self.text

            if !context.coordinator.didBecomeFirstResponder {

            uiView.becomeFirstResponder()
        context.coordinator.didBecomeFirstResponder = true

        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // call in next render cycle.
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        var didBecomeFirstResponder = false

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}
