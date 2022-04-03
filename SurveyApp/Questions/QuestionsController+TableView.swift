//
//  QuestionsController+TableView.swift
//  SurveyApp
//
//  Created by sanad barjawi on 03/04/2022.
//

import UIKit

extension QuestionsController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.survey?.questions.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.survey?.questions[section].answers.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier, for: indexPath) as? AnswerCell
        else {return UITableViewCell()}
        
        guard let answer = viewModel.survey?.questions[indexPath.section].answers[indexPath.row] else {return UITableViewCell()}
        let viewModel = AnswerCellViewModel(answer: answer.title, isSelected: answer.isSelected ?? false)
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelected(at: indexPath)
        tableView.reloadData()
        viewModel.validateSubmit()
    }
    
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as? QuestionCell,
              let question = viewModel.survey?.questions[section].query
        else {return nil}
        
        cell.viewModel = QuestionCellViewModel(question: question)
        return cell
    }
}
