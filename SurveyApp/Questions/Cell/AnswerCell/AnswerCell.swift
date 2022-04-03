//
//  QuestionCell.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import UIKit

class AnswerCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var selectedImageView: UIImageView!

    static var identifier: String = String(format: "%@", "\(AnswerCell.self)")
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedImageView.image = UIImage(systemName: "circle")
    }
    
    var viewModel: AnswerCellViewModel? {
        didSet {
            configureData()
        }
    }
    
    func configureData() {
        self.titleLabel.text = viewModel?.answer
        self.selectedImageView.image = UIImage(systemName: (viewModel?.isSelected ?? false) ? "circle.fill" : "circle")
    }
    
}
