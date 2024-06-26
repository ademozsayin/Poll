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
    func configureCell(searchModel: PostModel, indexpath: IndexPath)
}

//protocol PostTableViewCellDelegate: AnyObject {
//    func didUserVoteAt(option: Post.Option)
//}

final class PostTableViewCell: UITableViewCell, PostResultCell {
    
    typealias PostModel = ViewModel

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var postTitleLabel: UILabel!
    @IBOutlet private weak var avatarView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var totalVotesLabel: UILabel!
    @IBOutlet private weak var lastVotedTimeLabel: UILabel!
    @IBOutlet private weak var voteContainerView: UIView!
    let voteView1 = VoteView()
    let voteView2 = VoteView()
    
//    weak var delegate:PostTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configureBackground()
        configureLabels()
        configureVoteView()
    }
    
    static func register(for tableView: UITableView) {
        tableView.registerNib(for: self)
    }

    
    func configureCell(searchModel: ViewModel, indexpath: IndexPath) {
        configureCell(viewModel: searchModel, indexPath: indexpath )
    }
    
    private func configureVoteView() {
        let stackView = UIStackView(arrangedSubviews: [voteView1, voteView2])
        
        voteView1.layer.masksToBounds = true
        voteView1.layer.cornerRadius = 16
        voteView1.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        voteView2.layer.masksToBounds = true
        voteView2.layer.cornerRadius = 16
        voteView2.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 16
        voteContainerView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: voteContainerView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: voteContainerView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: voteContainerView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: voteContainerView.bottomAnchor).isActive = true
        
    }
    
    func configureCell(viewModel: ViewModel, indexPath: IndexPath) {
      
        username.text = viewModel.username
        postTitleLabel.text = viewModel.title
        if let avatar = viewModel.avatar {
            avatarView.image = avatar
        }
        dateLabel.text = viewModel.date.relativelyFormattedUpdateString
        if let lastVotedDate = viewModel.lastVotedDate {
            lastVotedTimeLabel.text = "Last Voted \(lastVotedDate.relativelyFormattedUpdateString)".uppercased()
        }
        totalVotesLabel.text = "\(viewModel.totalVoteCount) Total Votes"
        
        configureVoteViewWith(viewModel, indexPath: indexPath)
    }
    
    private func configureVoteViewWith(_ viewModel: ViewModel, indexPath: IndexPath) {
        
   
        let firstOption = viewModel.options[0]
        let secondOption = viewModel.options[1]
    
        voteView1.configure(
            with: firstOption,
            isVoted: viewModel.isVoted,
            voteRatio: viewModel.totalVoteCount == 0 ? 0 : viewModel.getRatio(for: firstOption),
            isVotedByCurrentUser: viewModel.votedUsers.contains(where: {$0.postId == viewModel.id && $0.selectedOption.id == firstOption.id}),
            indexPath: indexPath
            
        )
        voteView2.configure(
            with: secondOption,
            isVoted: viewModel.isVoted,
            voteRatio: viewModel.totalVoteCount == 0 ? 0 : viewModel.getRatio(for: secondOption),
            isVotedByCurrentUser: viewModel.votedUsers.contains(where: {$0.postId == viewModel.id && $0.selectedOption.id == secondOption.id}),
            indexPath: indexPath
        )
    }
}

// MARK: - Setup
//
private extension PostTableViewCell {
    func configureBackground() {
        self.backgroundColor = .clear
        containerView.backgroundColor = .white
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 16
        
        voteContainerView.layer.masksToBounds = true
        voteContainerView.layer.cornerRadius = 16
        
        //rgba(147, 162, 180, 1)
    }
    
    /// Setup: Labels
    ///
    func configureLabels() {
        postTitleLabel.applyTitleStyle()
        dateLabel.applyFootnoteStyle()
        lastVotedTimeLabel.applyFootnoteStyle()
        totalVotesLabel.applyCalloutStyle()
        avatarView.roundedImage()

    }
}


// MARK: - CellViewModel subtype
//
extension PostTableViewCell {
    struct ViewModel: Hashable {
        
        /// A unique ID to avoid duplicated identifier for the view model in diffable datasource.
        /// Please make sure to override this variable with a value corresponding to the content of the cell if you use diffable datasource,
        /// to avoid unnecessary animation when reloading the table view.
        var id: String
        let title: String
        let username: String
        let avatar: UIImage?
        let date: Date
        let lastVotedDate: Date?
        let totalVoteCount:Int
        var options: [Post.Option]
        let isVoted: Bool 
        let currentUser: User?
        let votedUsers:[VotedBy]
        
    }
}

extension PostTableViewCell.ViewModel {
    func getRatio(for option: Post.Option) -> Double {
        return  Double(option.voted)  / Double(totalVoteCount) * 100
    }
    
//    func isCurrentUserVoted() -> Bool {
//        return votedUsers.contains(where: { votedBy in
//            votedBy.postId == id && options.contains(where: { $0.id == votedBy.selectedOption.id })
//        })
//    }
}

fileprivate extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = (self.frame.size.width) / 2;
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }
}
