import Foundation

struct Flashcard {
    let question: String
    let answer: String
}

struct Exam {
    var name: String
    var cards: [Flashcard]

    var cardCount: Int {
        return cards.count
    }
}
