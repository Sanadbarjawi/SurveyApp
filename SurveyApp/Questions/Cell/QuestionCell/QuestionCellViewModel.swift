//
//  QuestionCellViewModel.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import Foundation

class QuestionCellViewModel {
    var question: Box<String> = .init("")
    
    init(question: String) {
        self.question.value = question
    }
}
