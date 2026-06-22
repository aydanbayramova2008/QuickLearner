import UIKit

class ViewController: UIViewController {

    var exams: [Exam] = [
        Exam(name: "Swift Exam", cards: [
            Flashcard(question: "What is the difference between \"var\" and \"let\"?", answer: "\"var\" is a mutable variable, \"let\" is an immutable constant"),
            Flashcard(question: "What does Optional (?) mean?", answer: "It represents whether a value may or may not exist"),
            Flashcard(question: "How do we unwrap an Optional?", answer: "Using if let, guard let, or force unwrapping (!)"),
            Flashcard(question: "What is a closure?", answer: "A self-contained block of code that can be stored and passed around like a variable"),
            Flashcard(question: "What is the difference between Array and Dictionary?", answer: "Array is an ordered list accessed by index; Dictionary stores key-value pairs"),
            Flashcard(question: "What does the \"->\" symbol mean in a function?", answer: "It indicates the return type of the function"),
            Flashcard(question: "What is the \"guard\" statement used for?", answer: "To exit a function early if a condition is not met"),
            Flashcard(question: "What is string interpolation?", answer: "A way to insert a variable's value inside a string using \\(variable)"),
            Flashcard(question: "What does a \"for-in\" loop do?", answer: "It iterates over each element in a collection (array, dictionary)"),
            Flashcard(question: "What does \"nil\" mean in Swift?", answer: "The absence of a value; can only be assigned to Optional types")
        ])
    ]

    var filteredExams: [Exam] = []
    var isSearching = false

    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let addButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        titleLabel.text = "QuickLearner"
        titleLabel.font = .boldSystemFont(ofSize: 28)

        subtitleLabel.text = "My Exams"
        subtitleLabel.font = .boldSystemFont(ofSize: 18)

        searchBar.placeholder = "Search exam sets..."
        searchBar.delegate = self

        tableView.dataSource = self
        tableView.delegate = self

        addButton.setTitle("+", for: .normal)
        addButton.backgroundColor = UIColor(red: 1.0, green: 0.84, blue: 0.91, alpha: 1.0)
        addButton.tintColor = .black
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        addButton.layer.cornerRadius = 28
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(subtitleLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    @objc func addButtonTapped() {
        let addVC = AddExamViewController()
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    var currentExams: [Exam] {
        return isSearching ? filteredExams : exams
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentExams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "examCell")
        let exam = currentExams[indexPath.row]
        cell.textLabel?.text = exam.name
        cell.detailTextLabel?.text = "\(exam.cardCount) cards"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedExam = currentExams[indexPath.row]
        let quizVC = QuizViewController()
        quizVC.exam = selectedExam
        navigationController?.pushViewController(quizVC, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filteredExams = exams.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}

extension ViewController: AddExamDelegate {
    func didAddExam(_ exam: Exam) {
        exams.append(exam)
        tableView.reloadData()
    }
}
