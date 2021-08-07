import UIKit

struct CheckItem {
    var name: String
    var isChecked: Bool
}

class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private var indexPathNumber: Int?

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

        switch identifier {
        case "addSegue":
            guard let navigationController = segue.destination as? UINavigationController, let inputTextVC = navigationController.topViewController as? InputTextViewController else { return }
            inputTextVC.delegate = self
            inputTextVC.mode = .add

        case "editSegue":
            guard let navigationController = segue.destination as? UINavigationController, let inputTextVC = navigationController.topViewController as? InputTextViewController else { return }
            inputTextVC.delegate = self
            inputTextVC.mode = .edit

            if let indexPath = sender as? IndexPath {
                let itemName = self.checkItems[indexPath.row].name
                inputTextVC.nameText = itemName
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellIdentifier, for: indexPath) as? CustomTableViewCell
        cell?.configure(item: checkItems[indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkItems[indexPath.row].isChecked.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        indexPathNumber = indexPath.row
        performSegue(withIdentifier: "editSegue", sender: indexPath)
    }
}

extension MainViewController: InputTextDelegate {
    func saveAddAndReturn(fruitsName: String) {
        checkItems.append(CheckItem(name: fruitsName, isChecked: false))
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }

    func saveEditAndReturn(fruitsName: String) {
        checkItems[indexPathNumber!].name = fruitsName
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
}
