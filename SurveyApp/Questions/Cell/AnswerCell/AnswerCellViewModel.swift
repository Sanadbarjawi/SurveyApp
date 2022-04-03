//
//  AnswerCellViewModel.swift
//  SurveyApp
//
//  Created by sanad barjawi on 03/04/2022.
//

import Foundation

class AnswerCellViewModel {
    var answer: Box<String> = .init("")
    
    init(answer: String) {
        self.answer.value = answer
    }
}
