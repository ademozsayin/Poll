//
//  Post.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

public struct Post: Decodable {
    
    // MARK: - Properties
    let id: String
    let createdAt: Date
    let content: String
    var options: [Option]
    let user: User?
    var lastVoteAt: Date?
    var votedBys: [VotedBy]
    
    public init(id: String, createdAt: Date, content: String, options: [Option], user: User?, lastVoteAt: Date? = nil, votedBys: [VotedBy]) {
        self.id = id
        self.createdAt = createdAt
        self.content = content
        self.options = options
        self.user = user
        self.lastVoteAt = lastVoteAt
        self.votedBys = votedBys
    }
}

public struct VotedBy: Decodable, Hashable {
    var user: User
    var postId: String?
    var selectedOption: Post.Option
    
    init(user: User, postId: String? = nil, selectedOption: Post.Option) {
        self.user = user
        self.postId = postId
        self.selectedOption = selectedOption
    }
}
