//
//  QuestionCell.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier: String = String(format: "%@", "\(QuestionCell.self)")
    
    var viewModel: QuestionCellViewModel? {
        didSet {
            setupBindings()
        }
    }
    
    func setupBindings() {
        
        viewModel?.question.bind({ string in
            self.titleLabel.text = string
        })
    }
    
}
