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
        case error(QuestionsViewModelError)
    }
    
    @Published private(set) var questions: [Question] = []
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
}
