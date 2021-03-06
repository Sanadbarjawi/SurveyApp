//
//  QuestionsViewModel.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import Foundation
import Combine

final class QuestionsViewModel {
    
    enum QuestionsViewModelError: Error, Equatable {
        case couldntLoadQuestions
    }

    enum QuestionsViewModelState: Equatable {
        case loading
        case finishedLoading
        case submitSucceeded
        case submitFailed
        case error(QuestionsViewModelError)
    }
    
    @Published private(set) var survey: Survey?
    @Published private(set) var state: QuestionsViewModelState = .loading
    @Published private(set) var isSubmitButtonEnabled: Bool = false
    
    private var service: QuestionServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: QuestionServiceProtocol = QuestionService()) {
        self.service = service
    }
    
}

extension QuestionsViewModel {
    func getSurvey() {
        state = .loading
        
        let onCompletion: (Subscribers.Completion<Error>) -> Void = {[weak self] completion in
            switch completion {
            case .finished:
                self?.state = .finishedLoading
            case .failure:
                self?.state = .error(QuestionsViewModelError.couldntLoadQuestions)
            }
        }
        
        let valueHandler: (Survey) -> Void = { [weak self] survey in
            self?.survey = survey
        }
        service
            .getSurvey()
            .sink(receiveCompletion: onCompletion, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
    
    func setSelected(at indexPath: IndexPath) {
        survey?.questions[indexPath.section].answers = survey?.questions[indexPath.section].answers.compactMap { answer -> Answer? in
            let tempAnswer: Answer = answer
            tempAnswer.isSelected = false
            return tempAnswer
        } ?? []
        survey?.questions[indexPath.section].answers[indexPath.row].isSelected = true
    }
    
    func validateSubmit() {
        
        if survey?.questions.allSatisfy({ question in
            return question.answers.filter({$0.isSelected == true}).count == 1
        }) == true {
            isSubmitButtonEnabled = true
        } else {
            isSubmitButtonEnabled = false
        }
    }
    
    func validateAnswers() {
        
        if survey?.questions.allSatisfy({ question in
            return question.answers.filter({$0.isSelected == true && $0.correct == true}).count == 1
        }) == true {
            //did succeed quiz
            print("success")
            self.state = .submitSucceeded
            
        } else {
            print("fail")
            self.state = .submitFailed
            //did fail quiz
        }
    }
}
