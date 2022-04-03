//
//  QuestionCell.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import UIKit

class AnswerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier: String = String(format: "%@", "\(AnswerCell.self)")
    
    var viewModel: AnswerCellViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    func setupBindings() {
        
        viewModel?.answer.bind({ string in
            self.titleLabel.text = string
        })
    }
    
}
