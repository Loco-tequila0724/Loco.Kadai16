import UIKit

struct CheckItem {
    var name: String
    var isChecked: Bool
}

class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private var tappedRow: Int?

    private var checkItems: [CheckItem] =
        [
        CheckItem(name: "りんご", isChecked: false),
        CheckItem(name: "みかん", isChecked: true),
        CheckItem(name: "バナナ", isChecked: false),
        CheckItem(name: "パイナップル", isChecked: true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        guard let navigationController = segue.destination as? UINavigationController, let inputTextVC = navigationController.topViewController as? InputTextViewController else { return }

        inputTextVC.delegate = self

        switch identifier {
        case "addSegue":
            inputTextVC.mode = .add
        case "editSegue":
            if let tappedRow = tappedRow {
                inputTextVC.mode = .edit(checkItems[tappedRow])
            }
        default:
            break
        }
    }
    @IBAction private func exit(segue: UIStoryboardSegue) {
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.configure(item: checkItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkItems[indexPath.row].isChecked.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        tappedRow = indexPath.row
        performSegue(withIdentifier: "editSegue", sender: indexPath)
    }
}

extension MainViewController: InputTextViewControllerDelegate {
    func saveAddAndReturn(fruitsName: String) {
        checkItems.append(CheckItem(name: fruitsName, isChecked: false))
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }

    func saveEditAndReturn(fruitsName: String) {
        guard let tappedRow = tappedRow else { return }
        checkItems[tappedRow].name = fruitsName
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
}
