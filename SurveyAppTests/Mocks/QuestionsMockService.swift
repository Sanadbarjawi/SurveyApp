//
//  QuestionsMockService.swift
//  SurveyAppTests
//
//  Created by sanad barjawi on 03/04/2022.
//

import Foundation
import Combine
@testable import SurveyApp

class QuestionsMockService: QuestionServiceProtocol {
    static let survey = Survey(questions: [
        Question(query: "How old are you?",
                 answers: [Answer(title: "2", correct: false),
                           Answer(title: "4", correct: true)])
    ])

    var getResult: Result<Survey, Error>!
    
    func getSurvey() -> AnyPublisher<Survey, Error> {
        getResult.publisher.eraseToAnyPublisher()
    }
    
}
