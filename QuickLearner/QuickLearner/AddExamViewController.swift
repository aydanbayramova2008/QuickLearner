import UIKit

protocol AddExamDelegate: AnyObject {
    func didAddExam(_ exam: Exam)
}

class AddExamViewController: UIViewController {

    weak var delegate: AddExamDelegate?
    private var cards: [Flashcard] = []

    private let nameField = UITextField()
    private let tableView = UITableView()
    private let addCardButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Exam"
        setupUI()
    }

    private func setupUI() {
        nameField.placeholder = "Exam name"
        nameField.borderStyle = .roundedRect

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cardCell")

        addCardButton.setTitle("+ Add Flashcard", for: .normal)
        addCardButton.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)

        saveButton.setTitle("Save Exam", for: .normal)
        saveButton.backgroundColor = UIColor(red: 1.0, green: 0.84, blue: 0.91, alpha: 1.0)
        saveButton.tintColor = .black
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        [nameField, tableView, addCardButton, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            addCardButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            tableView.topAnchor.constraint(equalTo: addCardButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),

            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func addCardTapped() {
        let alert = UIAlertController(title: "New Flashcard", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Question" }
        alert.addTextField { $0.placeholder = "Answer" }

        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let question = alert.textFields?[0].text, !question.isEmpty,
                  let answer = alert.textFields?[1].text, !answer.isEmpty else { return }
            self?.cards.append(Flashcard(question: question, answer: answer))
            self?.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func saveTapped() {
        guard let name = nameField.text, !name.isEmpty else {
            showAlert("Please enter an exam name"); return
        }
        guard !cards.isEmpty else {
            showAlert("Please add at least one flashcard"); return
        }
        let newExam = Exam(name: name, cards: cards)
        delegate?.didAddExam(newExam)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AddExamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        cell.textLabel?.text = cards[indexPath.row].question
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cards.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
