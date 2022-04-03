//
//  AnswerCellViewModel.swift
//  SurveyApp
//
//  Created by sanad barjawi on 03/04/2022.
//

import Foundation
import Combine

class AnswerCellViewModel {
    var answer: String
    var isSelected: Bool = false
    
    init(answer: String, isSelected: Bool) {
        self.answer = answer
        self.isSelected = isSelected
    }
}
