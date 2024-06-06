//
//  PostTableViewCell.swift
//  Pollexa
//
//  Created by Adem Özsayın on 6.06.2024.
//

import UIKit

protocol PostResultCell {
    associatedtype PostModel
    
    static func register(for tableView: UITableView)
    func configureCell(searchModel: PostModel)
}


class PostTableViewCell: UITableViewCell, PostResultCell {
    
    typealias PostModel = ViewModel
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureBackground()
        configureLabels()
    }
    
    static func register(for tableView: UITableView) {
        tableView.registerNib(for: self)
    }

    
    func configureCell(searchModel: ViewModel) {
        configureCell(viewModel: searchModel)
    }
    
    func configureCell(viewModel: ViewModel) {
        titleLabel.text = viewModel.title
             
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        updateDefaultBackgroundConfiguration(using: state)
    }
    
}

// MARK: - Setup
//
private extension PostTableViewCell {
    func configureBackground() {
        configureDefaultBackgroundConfiguration()
    }
    
    /// Setup: Labels
    ///
    func configureLabels() {
//        subtitleLabel.applyCaption1Style()
//        titleLabel.applyBodyStyle()
//        statusLabel.applyFootnoteStyle()
//        statusLabel.numberOfLines = 0
//        statusLabel.textColor = .black // constant because there will always background color on the label
//        statusLabel.layer.cornerRadius = CGFloat(4.0)
//        statusLabel.layer.masksToBounds = true
    }
}


// MARK: - CellViewModel subtype
//
extension PostTableViewCell {
    struct ViewModel: Hashable {
        /// A unique ID to avoid duplicated identifier for the view model in diffable datasource.
        /// Please make sure to override this variable with a value corresponding to the content of the cell if you use diffable datasource,
        /// to avoid unnecessary animation when reloading the table view.
        var id: String = UUID().uuidString
        let title: String
        let username: String
       
    }
}