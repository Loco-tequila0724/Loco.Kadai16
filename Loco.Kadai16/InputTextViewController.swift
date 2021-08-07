import UIKit

protocol InputTextDelegate: AnyObject {
    func saveAddAndReturn(fruitsName: String)
    func saveEditAndReturn(fruitsName: String)
}

class InputTextViewController: UIViewController {
    enum Mode: String {
        case add
        case edit
    }

    @IBOutlet private weak var inputTextField: UITextField!

    var nameText = ""
    var mode: Mode?

    weak var delegate: InputTextDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.text = nameText
    }

    private func presentAlert(message: String) {
        let alert = UIAlertController(
            title: "警告",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
        )
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func saveTextButton(_ sender: Any) {
        guard let inputText = inputTextField.text, !inputText.isEmpty else {
            presentAlert(message: "名前を入力してください。")
            return
        }

        switch mode {
        case .add:
            delegate?.saveAddAndReturn(fruitsName: inputText)
        case .edit:
            delegate?.saveEditAndReturn(fruitsName: inputText)
        default:
            break
        }
    }
}
