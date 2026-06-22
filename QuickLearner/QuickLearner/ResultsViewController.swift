import UIKit

class ResultsViewController: UIViewController {

    var examName = ""
    var totalCards = 0
    var correctCount = 0
    var wrongCount = 0
    var wrongCards: [Flashcard] = []

    let pinkColor = UIColor(red: 1.0, green: 0.84, blue: 0.91, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupUI()
    }

    func setupUI() {
        let percent = totalCards > 0 ? Int((Double(correctCount) / Double(totalCards)) * 100) : 0

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.text = "Session Complete!"
        titleLabel.font = .boldSystemFont(ofSize: 26)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(examName) · \(totalCards) cards reviewed"
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray

        let ringContainer = UIView()
        let percentLabel = UILabel()
        percentLabel.text = "\(percent)%"
        percentLabel.font = .boldSystemFont(ofSize: 38)
        percentLabel.textAlignment = .center

        let scoreLabel = UILabel()
        scoreLabel.text = "Score"
        scoreLabel.font = .systemFont(ofSize: 14)
        scoreLabel.textColor = .gray
        scoreLabel.textAlignment = .center

        let correctBox = makeStatBox(count: correctCount, label: "CORRECT ✓", color: .systemGreen)
        let wrongBox = makeStatBox(count: wrongCount, label: "WRONG ✗", color: .systemRed)

        let statsStack = UIStackView(arrangedSubviews: [correctBox, wrongBox])
        statsStack.axis = .horizontal
        statsStack.spacing = 12
        statsStack.distribution = .fillEqually

        let messageLabel = UILabel()
        messageLabel.text = motivationMessage(for: percent)
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        let messageBox = UIView()
        messageBox.backgroundColor = pinkColor.withAlphaComponent(0.3)
        messageBox.layer.cornerRadius = 14

        let backHomeButton = UIButton(type: .system)
        backHomeButton.setTitle("Back to Home", for: .normal)
        backHomeButton.backgroundColor = pinkColor
        backHomeButton.tintColor = .black
        backHomeButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        backHomeButton.layer.cornerRadius = 14
        backHomeButton.addTarget(self, action: #selector(backHomeTapped), for: .touchUpInside)

        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry Wrong (\(wrongCount))", for: .normal)
        retryButton.setTitleColor(.black, for: .normal)
        retryButton.backgroundColor = .white
        retryButton.layer.cornerRadius = 14
        retryButton.layer.borderWidth = 1.5
        retryButton.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        retryButton.isEnabled = wrongCount > 0
        retryButton.alpha = wrongCount > 0 ? 1.0 : 0.4
        retryButton.addTarget(self, action: #selector(retryWrongTapped), for: .touchUpInside)

        [backButton, titleLabel, subtitleLabel, ringContainer, percentLabel, scoreLabel, statsStack, messageBox, messageLabel, backHomeButton, retryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        ringContainer.addSubview(percentLabel)
        ringContainer.addSubview(scoreLabel)
        messageBox.addSubview(messageLabel)

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(ringContainer)
        view.addSubview(statsStack)
        view.addSubview(messageBox)
        view.addSubview(backHomeButton)
        view.addSubview(retryButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            ringContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            ringContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ringContainer.widthAnchor.constraint(equalToConstant: 200),
            ringContainer.heightAnchor.constraint(equalToConstant: 200),

            percentLabel.centerXAnchor.constraint(equalTo: ringContainer.centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: ringContainer.centerYAnchor, constant: -10),

            scoreLabel.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 2),
            scoreLabel.centerXAnchor.constraint(equalTo: ringContainer.centerXAnchor),

            statsStack.topAnchor.constraint(equalTo: ringContainer.bottomAnchor, constant: 28),
            statsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsStack.heightAnchor.constraint(equalToConstant: 90),

            messageBox.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 20),
            messageBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: messageBox.topAnchor, constant: 14),
            messageLabel.bottomAnchor.constraint(equalTo: messageBox.bottomAnchor, constant: -14),
            messageLabel.leadingAnchor.constraint(equalTo: messageBox.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageBox.trailingAnchor, constant: -16),

            retryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            retryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            retryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            retryButton.heightAnchor.constraint(equalToConstant: 52),

            backHomeButton.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -12),
            backHomeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backHomeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backHomeButton.heightAnchor.constraint(equalToConstant: 52)
        ])

        view.layoutIfNeeded()
        drawRing(in: ringContainer, percent: percent)
    }

    func makeStatBox(count: Int, label: String, color: UIColor) -> UIView {
        let box = UIView()
        box.backgroundColor = color.withAlphaComponent(0.1)
        box.layer.cornerRadius = 14
        box.layer.borderWidth = 1
        box.layer.borderColor = color.withAlphaComponent(0.3).cgColor

        let countLabel = UILabel()
        countLabel.text = "\(count)"
        countLabel.font = .boldSystemFont(ofSize: 26)
        countLabel.textColor = color
        countLabel.textAlignment = .center

        let captionLabel = UILabel()
        captionLabel.text = label
        captionLabel.font = .systemFont(ofSize: 12)
        captionLabel.textColor = color
        captionLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [countLabel, captionLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        box.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: box.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: box.centerYAnchor)
        ])

        return box
    }

    func motivationMessage(for percent: Int) -> String {
        if percent >= 90 {
            return "🎉 Excellent work! You really know your stuff."
        } else if percent >= 70 {
            return "🎉 Great job! Keep it up and aim for 100%."
        } else if percent >= 50 {
            return "💪 Good effort! Review the ones you missed."
        } else {
            return "📚 Keep practicing, you'll get there!"
        }
    }

    func drawRing(in container: UIView, percent: Int) {
        let center = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        let radius = container.bounds.width / 2 - 12

        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true).cgPath
        backgroundLayer.strokeColor = UIColor(white: 0.93, alpha: 1.0).cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 16
        container.layer.addSublayer(backgroundLayer)

        let progressLayer = CAShapeLayer()
        progressLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true).cgPath
        progressLayer.strokeColor = pinkColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 16
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(percent) / 100.0
        container.layer.addSublayer(progressLayer)
    }

    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func backHomeTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func retryWrongTapped() {
        guard !wrongCards.isEmpty else { return }
        let retryExam = Exam(name: "\(examName) (Retry)", cards: wrongCards)
        let quizVC = QuizViewController()
        quizVC.exam = retryExam
        navigationController?.pushViewController(quizVC, animated: true)
    }
}
