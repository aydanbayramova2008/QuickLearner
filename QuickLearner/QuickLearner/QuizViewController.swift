import UIKit

class QuizViewController: UIViewController {

    var exam: Exam!
    var currentIndex = 0
    var correctCount = 0
    var wrongCount = 0
    var wrongCards: [Flashcard] = []
    var timer: Timer?
    var timeRemaining = 60

    let pinkColor = UIColor(red: 1.0, green: 0.84, blue: 0.91, alpha: 1.0)

    let backButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let progressLabel = UILabel()
    let percentLabel = UILabel()
    let progressBarBackground = UIView()
    let progressBarFill = UIView()
    var progressFillWidthConstraint: NSLayoutConstraint!

    let timerRingView = UIView()
    let timerRingLayer = CAShapeLayer()
    let timerBackgroundLayer = CAShapeLayer()
    let timerLabel = UILabel()

    let cardView = UIView()
    let questionEyebrow = UILabel()
    let questionLabel = UILabel()
    let answerEyebrow = UILabel()
    let answerLabel = UILabel()

    let showAnswerButton = UIButton(type: .system)
    let knewItButton = UIButton(type: .system)
    let didntKnowButton = UIButton(type: .system)
    let previousButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupUI()
        loadQuestion()
    }

    func setupUI() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        titleLabel.text = exam.name
        titleLabel.font = .boldSystemFont(ofSize: 22)

        progressLabel.font = .boldSystemFont(ofSize: 15)
        percentLabel.font = .systemFont(ofSize: 14)
        percentLabel.textColor = .gray

        progressBarBackground.backgroundColor = UIColor(white: 0.93, alpha: 1.0)
        progressBarBackground.layer.cornerRadius = 3
        progressBarFill.backgroundColor = pinkColor
        progressBarFill.layer.cornerRadius = 3

        timerLabel.font = .boldSystemFont(ofSize: 17)
        timerLabel.textAlignment = .center

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 12

        questionEyebrow.text = "QUESTION"
        questionEyebrow.font = .boldSystemFont(ofSize: 12)
        questionEyebrow.textColor = UIColor(red: 0.9, green: 0.4, blue: 0.6, alpha: 1.0)
        questionEyebrow.textAlignment = .center

        questionLabel.font = .boldSystemFont(ofSize: 20)
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center

        answerEyebrow.text = "ANSWER"
        answerEyebrow.font = .boldSystemFont(ofSize: 12)
        answerEyebrow.textColor = .gray
        answerEyebrow.textAlignment = .center
        answerEyebrow.isHidden = true

        answerLabel.font = .systemFont(ofSize: 17)
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .center
        answerLabel.textColor = .darkGray
        answerLabel.isHidden = true

        showAnswerButton.setTitle("Show Answer", for: .normal)
        showAnswerButton.backgroundColor = pinkColor
        showAnswerButton.tintColor = .black
        showAnswerButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        showAnswerButton.layer.cornerRadius = 14
        showAnswerButton.addTarget(self, action: #selector(showAnswerTapped), for: .touchUpInside)

        knewItButton.setTitle("✓ I Knew It", for: .normal)
        knewItButton.setTitleColor(UIColor.systemGreen, for: .normal)
        knewItButton.backgroundColor = .white
        knewItButton.layer.cornerRadius = 14
        knewItButton.layer.borderWidth = 1.5
        knewItButton.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.4).cgColor
        knewItButton.isHidden = true
        knewItButton.addTarget(self, action: #selector(knewItTapped), for: .touchUpInside)

        didntKnowButton.setTitle("✗ Didn't Know", for: .normal)
        didntKnowButton.setTitleColor(.gray, for: .normal)
        didntKnowButton.backgroundColor = .white
        didntKnowButton.layer.cornerRadius = 14
        didntKnowButton.layer.borderWidth = 1.5
        didntKnowButton.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        didntKnowButton.isHidden = true
        didntKnowButton.addTarget(self, action: #selector(didntKnowTapped), for: .touchUpInside)

        previousButton.setTitle("← Previous", for: .normal)
        previousButton.tintColor = .gray
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)

        nextButton.setTitle("Next →", for: .normal)
        nextButton.tintColor = .gray
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        [backButton, titleLabel, progressLabel, percentLabel, progressBarBackground, progressBarFill, timerRingView, timerLabel, cardView, questionEyebrow, questionLabel, answerEyebrow, answerLabel, showAnswerButton, knewItButton, didntKnowButton, previousButton, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        cardView.addSubview(questionEyebrow)
        cardView.addSubview(questionLabel)
        cardView.addSubview(answerEyebrow)
        cardView.addSubview(answerLabel)
        progressBarBackground.addSubview(progressBarFill)
        timerRingView.addSubview(timerLabel)

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(progressLabel)
        view.addSubview(percentLabel)
        view.addSubview(progressBarBackground)
        view.addSubview(timerRingView)
        view.addSubview(cardView)
        view.addSubview(showAnswerButton)
        view.addSubview(knewItButton)
        view.addSubview(didntKnowButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)

        progressFillWidthConstraint = progressBarFill.widthAnchor.constraint(equalTo: progressBarBackground.widthAnchor, multiplier: 0)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 12),

            progressLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            percentLabel.centerYAnchor.constraint(equalTo: progressLabel.centerYAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: timerRingView.leadingAnchor, constant: -16),

            progressBarBackground.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarBackground.trailingAnchor.constraint(equalTo: timerRingView.leadingAnchor, constant: -16),
            progressBarBackground.heightAnchor.constraint(equalToConstant: 6),

            progressBarFill.leadingAnchor.constraint(equalTo: progressBarBackground.leadingAnchor),
            progressBarFill.topAnchor.constraint(equalTo: progressBarBackground.topAnchor),
            progressBarFill.bottomAnchor.constraint(equalTo: progressBarBackground.bottomAnchor),
            progressFillWidthConstraint,

            timerRingView.centerYAnchor.constraint(equalTo: progressBarBackground.centerYAnchor, constant: -8),
            timerRingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerRingView.widthAnchor.constraint(equalToConstant: 64),
            timerRingView.heightAnchor.constraint(equalToConstant: 64),

            timerLabel.centerXAnchor.constraint(equalTo: timerRingView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerRingView.centerYAnchor),

            cardView.topAnchor.constraint(equalTo: progressBarBackground.bottomAnchor, constant: 36),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 220),

            questionEyebrow.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            questionEyebrow.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            questionLabel.topAnchor.constraint(equalTo: questionEyebrow.bottomAnchor, constant: 12),
            questionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            answerEyebrow.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            answerEyebrow.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            answerLabel.topAnchor.constraint(equalTo: answerEyebrow.bottomAnchor, constant: 8),
            answerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            answerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            answerLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -24),

            showAnswerButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 28),
            showAnswerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showAnswerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showAnswerButton.heightAnchor.constraint(equalToConstant: 54),

            knewItButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 28),
            knewItButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            knewItButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -6),
            knewItButton.heightAnchor.constraint(equalToConstant: 54),

            didntKnowButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 28),
            didntKnowButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 6),
            didntKnowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            didntKnowButton.heightAnchor.constraint(equalToConstant: 54),

            previousButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if timerBackgroundLayer.path == nil {
            drawTimerRing()
        }
    }

    func drawTimerRing() {
        let center = CGPoint(x: timerRingView.bounds.midX, y: timerRingView.bounds.midY)
        let radius = timerRingView.bounds.width / 2 - 4
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true).cgPath

        timerBackgroundLayer.path = path
        timerBackgroundLayer.strokeColor = UIColor(white: 0.93, alpha: 1.0).cgColor
        timerBackgroundLayer.fillColor = UIColor.clear.cgColor
        timerBackgroundLayer.lineWidth = 5
        timerRingView.layer.addSublayer(timerBackgroundLayer)

        timerRingLayer.path = path
        timerRingLayer.strokeColor = pinkColor.cgColor
        timerRingLayer.fillColor = UIColor.clear.cgColor
        timerRingLayer.lineWidth = 5
        timerRingLayer.lineCap = .round
        timerRingLayer.strokeEnd = 0
        timerRingView.layer.addSublayer(timerRingLayer)
    }

    func loadQuestion() {
        let card = exam.cards[currentIndex]
        let total = exam.cards.count
        let progressPercent = Int((Double(currentIndex + 1) / Double(total)) * 100)

        progressLabel.text = "Question \(currentIndex + 1) / \(total)"
        percentLabel.text = "\(progressPercent)%"
        progressFillWidthConstraint.isActive = false
        progressFillWidthConstraint = progressBarFill.widthAnchor.constraint(equalTo: progressBarBackground.widthAnchor, multiplier: CGFloat(progressPercent) / 100.0)
        progressFillWidthConstraint.isActive = true

        questionLabel.text = card.question
        answerLabel.text = card.answer
        answerEyebrow.isHidden = true
        answerLabel.isHidden = true
        showAnswerButton.isHidden = false
        knewItButton.isHidden = true
        didntKnowButton.isHidden = true

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }

        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timeRemaining = 60
        timerLabel.text = "60s"
        timerRingLayer.strokeEnd = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    @objc func tick() {
        timeRemaining -= 1
        timerLabel.text = "\(timeRemaining)s"
        timerRingLayer.strokeEnd = CGFloat(60 - timeRemaining) / 60.0
        if timeRemaining <= 0 {
            timer?.invalidate()
            wrongCount += 1
            wrongCards.append(exam.cards[currentIndex])
            goToNextQuestion()
        }
    }

    @objc func showAnswerTapped() {
        answerEyebrow.isHidden = false
        answerLabel.isHidden = false
        showAnswerButton.isHidden = true
        knewItButton.isHidden = false
        didntKnowButton.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func knewItTapped() {
        correctCount += 1
        timer?.invalidate()
        goToNextQuestion()
    }

    @objc func didntKnowTapped() {
        wrongCount += 1
        wrongCards.append(exam.cards[currentIndex])
        timer?.invalidate()
        goToNextQuestion()
    }

    @objc func previousTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            loadQuestion()
        }
    }

    @objc func nextTapped() {
        timer?.invalidate()
        goToNextQuestion()
    }

    @objc func backTapped() {
        timer?.invalidate()
        navigationController?.popViewController(animated: true)
    }

    func goToNextQuestion() {
        if currentIndex < exam.cards.count - 1 {
            currentIndex += 1
            loadQuestion()
        } else {
            timer?.invalidate()
            showResults()
        }
    }

    func showResults() {
        let resultsVC = ResultsViewController()
        resultsVC.examName = exam.name
        resultsVC.totalCards = exam.cards.count
        resultsVC.correctCount = correctCount
        resultsVC.wrongCount = wrongCount
        resultsVC.wrongCards = wrongCards
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}
