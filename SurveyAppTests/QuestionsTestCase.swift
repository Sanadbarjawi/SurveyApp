//
//  QuestionsTestCase.swift
//  SurveyAppTests
//
//  Created by sanad barjawi on 03/04/2022.
//

import XCTest
import Combine
@testable import SurveyApp

class QuestionsTestCase: XCTestCase {
    
    private var subject: QuestionsViewModel!
    private var questionsMockService: QuestionsMockService!

    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        super.setUp()
        questionsMockService = QuestionsMockService()
        
        subject = QuestionsViewModel(service: questionsMockService)

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        questionsMockService = nil
        subject = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func test_questions_service_givenServiceCallSucceeds_shouldUpdateSurvey() {
        // given
        questionsMockService.getResult = .success(QuestionsMockService.survey)

        // when
        subject.getSurvey()

        // then
        subject.$survey
            .sink { XCTAssertEqual($0?.questions.count, QuestionsMockService.survey.questions.count) }
            .store(in: &cancellables)

        subject.$state
            .sink { XCTAssertEqual($0, .finishedLoading) }
            .store(in: &cancellables)
    }


}
