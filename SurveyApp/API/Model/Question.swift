//
//  Question.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import Foundation

struct Survey: Codable {
    var questions: [Question]
}

struct Question: Codable {
    var query: String
    var answers: [Answer]
}

struct Answer: Codable {
    var title: String
    var correct: Bool
}
