import UIKit

class OneTimePasscodeTextField: UITextField {
    weak var previousTextField: OneTimePasscodeTextField?
    weak var nextTextField: OneTimePasscodeTextField?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        textAlignment = .center
        layer.cornerRadius = 8
        keyboardType = .numberPad
        autocorrectionType = .yes
        textContentType = .oneTimeCode
    }

    override func deleteBackward() {
        // If this text field is empty then we need to clear the previous text field and make it
        // the responder, doing so empties the text field and puts the text cursor into it.
        // This makes pressing backspace feel more natural. It also makes sure the user can
        // backspace the current field to type a new character.
        if let text = text, text.isEmpty {
            previousTextField?.text = ""
            previousTextField?.becomeFirstResponder()
        } else {
            text = ""
        }
    }
}
