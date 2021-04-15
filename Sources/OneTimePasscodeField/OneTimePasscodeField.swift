import UIKit

public class OneTimePasscodeField: UIControl {
    private let contentStack = UIStackView()

    private var textFields: [OneTimePasscodeTextField] {
        // swiftlint:disable:next force_cast
        contentStack.arrangedSubviews as! [OneTimePasscodeTextField]
    }

    // swiftlint:disable:next weak_delegate
    private lazy var textFieldDelegate = OneTimePasscodeTextFieldDelegate(parentField: self)

    public var text: String {
        get { textFields.compactMap(\.text).joined() }
        set { autoFillTextField(with: newValue) }
    }

    @objc public dynamic var textColor = UIColor.black {
        didSet {
            textFields.forEach {
                $0.textColor = textColor
            }
        }
    }

    @objc public dynamic var textBackgroundColor = UIColor(white: 1, alpha: 0.5) {
        didSet {
            textFields.forEach {
                $0.backgroundColor = textBackgroundColor
            }
        }
    }

    @objc public dynamic var font = UIFont.preferredFont(forTextStyle: .largeTitle) {
        didSet {
            textFields.forEach {
                $0.font = font
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // Handle touches inside this view, which without the following wouldn't trigger text entry
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isUserInteractionEnabled = false
        contentStack.contentMode = .center
        contentStack.distribution = .fillEqually
        contentStack.alignment = .fill
        contentStack.spacing = 10
        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])

        // Set up the text fields
        var previousTextField: OneTimePasscodeTextField?
        for _ in 0 ..< 6 {
            let textField = OneTimePasscodeTextField()
            textField.delegate = textFieldDelegate
            textField.backgroundColor = textBackgroundColor
            textField.font = font
            contentStack.addArrangedSubview(textField)

            // Create the linked list of fields
            previousTextField?.nextTextField = textField
            textField.previousTextField = previousTextField
            previousTextField = textField
        }
    }

    @objc private func touchUpInside() {
        _ = becomeFirstResponder()
    }

    override public func becomeFirstResponder() -> Bool {
        // Make sure to select the first empty text field, don't let the user start typing in the middle

        // swiftlint:disable:next force_unwrapping
        guard let emptyOrLastField = textFields.first(where: { $0.text!.isEmpty }) ?? textFields.last else {
            return super.becomeFirstResponder()
        }
        return emptyOrLastField.becomeFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        textFields.first(where: \.isFirstResponder)?.resignFirstResponder() ?? true
    }

    @discardableResult
    func autoFillTextField(with string: String) -> Bool {
        // Only allow numbers to be entered
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }

        // Distribute the characters into each of the textfields
        var reversedCharacters = string.reversed().compactMap { String($0) }
        for textField in textFields {
            guard let char = reversedCharacters.popLast() else { break }
            textField.text = String(char)
        }

        return true
    }

    public func clearTextFields() {
        for textField in textFields {
            textField.text = ""
        }
    }
}
