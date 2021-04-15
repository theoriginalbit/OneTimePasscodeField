import UIKit

class OneTimePasscodeTextFieldDelegate: NSObject, UITextFieldDelegate {
    let parentField: OneTimePasscodeField

    init(parentField: OneTimePasscodeField) {
        self.parentField = parentField
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // ensure the input is only numbers
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }

        // swiftlint:disable:next force_cast
        let textField = textField as! OneTimePasscodeTextField

        if string.count > 1 {
            // A code is being pasted or auto-filled
            textField.resignFirstResponder()
            parentField.autoFillTextField(with: string)
            return false
        }

        if string.count == 1 {
            if textField.nextTextField == nil {
                textField.text? = string
                textField.resignFirstResponder()
            } else {
                textField.text? = string
                textField.nextTextField?.becomeFirstResponder()
            }
            return false
        }

        return true
    }
}
