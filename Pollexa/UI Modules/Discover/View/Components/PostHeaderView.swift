//
//  PostHeaderView.swift
//  Pollexa
//
//  Created by Adem Özsayın on 7.06.2024.
//

import UIKit
import Foundation
import ColorPalette

final class PostHeaderView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var activePollsLabel: UILabel!
    @IBOutlet private weak var seeDetailsLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
        configureStyle()
    }
}

// MARK: - Public Methods
//
extension PostHeaderView {
    
    /// Active polls
    ///
    var pollsCount: String? {
        set {
            activePollsLabel.text = newValue
        }
        get {
            return activePollsLabel.text
        }
    }
}

// MARK: - Private Methods
//
private extension PostHeaderView {
    
    final func configureContainerView() {
        containerView.backgroundColor = UIColor.appColor
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 20
    }
    
    final func configureStyle() {
        activePollsLabel.applyHeadlineStyle()
        activePollsLabel.textColor = .white
        
        seeDetailsLabel.applySecondaryTitleStyle()
        seeDetailsLabel.textColor = .white.withAlphaComponent(0.5)
    }
}
