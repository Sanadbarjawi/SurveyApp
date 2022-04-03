//
//  QuestionsTableViewController.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import UIKit
import Combine

final class QuestionsController: UITableViewController {
    
    private var viewModel: QuestionsViewModel =
    QuestionsViewModel(service: QuestionService())
    
    @IBOutlet private var submitFooterView: UIView!
    @IBOutlet private weak var submitButton: UIButton!
    
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the custom header view.
        configureTableView()
        bindViewModelToView()
        viewModel.getSurvey()
        title = "Questions"
    }
    
    private func configureTableView() {
        
        let questionCell = UINib(nibName: "\(QuestionCell.self)", bundle: nil)
        tableView.register(questionCell, forCellReuseIdentifier: QuestionCell.identifier)
        
        let answerCell = UINib(nibName: "\(AnswerCell.self)", bundle: nil)
        tableView.register(answerCell, forCellReuseIdentifier: AnswerCell.identifier)
        
        tableView.tableFooterView = submitFooterView
        tableView.tableHeaderView = UIView()
        
    }
    
    private func bindViewModelToView() {
        
        viewModel.$survey
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            }).store(in: &cancellable)

        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: { state in
                switch state {
                case .loading: break
                    //start loading
                case .finishedLoading: break
                    //finish loading
                case .error(_): break
                    //show error
                }
            }).store(in: &cancellable)
        
        viewModel.$isSubmitButtonEnabled
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] isEnabled in
                self?.submitButton.isEnabled = isEnabled
                self?.submitButton.alpha = isEnabled ? 1.0 : 0.5
            }).store(in: &cancellable)
    }
    
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
        let answer = viewModel.survey?.questions[indexPath.section].answers[indexPath.row].title ?? "N/A"
        let viewModel = AnswerCellViewModel(answer: answer)
        cell.viewModel = viewModel
        return cell
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
