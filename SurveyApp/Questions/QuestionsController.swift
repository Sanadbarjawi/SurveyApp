//
//  QuestionsTableViewController.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import UIKit
import Combine

extension QuestionsController {
    static func getQuestionsController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Questions", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "\(QuestionsController.self)") { coder -> QuestionsController? in
            let viewModel = QuestionsViewModel(service: QuestionService())
            let questionsController = QuestionsController(coder: coder, viewModel: viewModel)
            return questionsController
        }
        return controller
//        controller.navigationController?.pushViewController(controller, animated: true)
    }
}

final class QuestionsController: UITableViewController {
    
    var viewModel: QuestionsViewModel =
    QuestionsViewModel(service: QuestionService())
    
    @IBOutlet private var submitFooterView: UIView!
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        }
    }
    
    init?(coder: NSCoder, viewModel: QuestionsViewModel) {
        super.init(coder: coder)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .loading: break
                    //start loading
                case .finishedLoading: break
                    //finish loading
                case .error(_): break
                    //show error
                case .submitSucceeded:
                    self?.showAlert(message: "Success")
                case .submitFailed:
                    self?.showAlert(message: "Failed")
                }
            }).store(in: &cancellable)
        
        viewModel.$isSubmitButtonEnabled
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] isEnabled in
                self?.submitButton.isEnabled = isEnabled
                self?.submitButton.alpha = isEnabled ? 1.0 : 0.5
            }).store(in: &cancellable)
    }
    
    @objc private func didTapSubmitButton() {
        viewModel.validateAnswers()
    }
    
}
