//
//  PostViewModel.swift
//  Pollexa
//
//  Created by Adem Özsayın on 6.06.2024.
//

import Foundation
import Combine

enum PostListState {
    case initialized
    case loading // View should show ghost cells
    case empty // View should display the empty state
    case posts
    case refreshing // View should display the refresh control
    case loadingNextPage
}

/// A view model for managing and displaying a list of posts.
final class PostViewModel: ObservableObject {
    
    /// The type used for cell view models.
    typealias CellViewModel = PostTableViewCell.ViewModel
    
    /// An array of cell view models for displaying posts in the UI.
    @Published private(set) var postsViewModels: [CellViewModel] = []
    
    /// The currently logged-in user.
    @Published private(set) var currentUser: User?
    
    /// An array of `Post` objects.
    private(set) var posts: [Post] = [] 
    /// The current state of the post list.
    @Published private(set) var state: PostListState = .loading
    
    /// The title of the page.
    @Published private(set) var pageTitle: String = Localization.pageTitle
    
    /// Initializes the view model and begins fetching posts.
    init()  {
        Task {
            await fetchPosts()
        }
    }
}

// MARK: - Public Methods

extension PostViewModel {
    /// Votes for a specific option in a post and updates the view models.
    ///
    /// - Parameters:
    ///   - option: The option to vote for.
    ///   - indexPath: The index path of the post in the table view.
    final func vote(at option: Post.Option, indexPath: IndexPath) {
        guard let postIndex = postIndex(for: indexPath) else {
            return
        }
        
        updatePostData(at: postIndex, with: option)
        buildPostViewModels()
    }
}

// MARK: - Private Methods
private extension PostViewModel {
    
    /// Loads pages of posts asynchronously.
    ///
    /// - Returns: An array of `Post` objects.
    /// - Throws: An error if the pages could not be loaded.
    @MainActor
    final func loadPosts() async throws -> [Post] {
        try await withCheckedThrowingContinuation { continuation in
            PostProvider.shared.fetchAll { result in
                switch result {
                    case .success(let pages):
                        continuation.resume(returning: pages)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Fetches posts asynchronously and updates the state and current user.
    @MainActor
    final func fetchPosts() async {
        do {
            posts = try await loadPosts()
            currentUser = posts.first?.user ?? nil
            buildPostViewModels()
        } catch {
            print("⛔️ Error loading pages: \(error)")
            state = .empty
        }
    }
    
    /// Builds view models for the posts and updates the state.
    final func buildPostViewModels() {
        postsViewModels = posts.map { post in
            CellViewModel(
                id: post.id,
                title: post.content,
                username: post.user?.username ?? "-",
                avatar: post.user?.image ?? nil,
                date: post.createdAt,
                lastVotedDate: post.lastVoteAt ?? nil,
                totalVoteCount: post.options.reduce(0) { $0 + $1.voted },
                options: post.options,
                isVoted: post.votedBys.contains { votedBy in
                    votedBy.postId == post.id && post.options.contains { $0.id == votedBy.selectedOption.id }
                },
                currentUser: currentUser,
                votedUsers: post.votedBys
            )
        }
        /// Simulate Data
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.state = self.postsViewModels.isEmpty ? .empty : .posts
        }
    }
    
    /// Retrieves the index of the post based on the index path.
    ///
    /// - Parameter indexPath: The index path of the post in the table view.
    /// - Returns: The index of the post in the `posts` array, or `nil` if the index path is invalid.
    final func postIndex(for indexPath: IndexPath) -> Int? {
        guard indexPath.row < posts.count else {
            return nil
        }
        return indexPath.row
    }
    
    
    // Updates the data for a post when a vote is cast.
    ///
    /// - Parameters:
    ///   - index: The index of the post in the `posts` array.
    ///   - option: The option that was voted for.
    final func updatePostData(at index: Int, with option: Post.Option) {
        var post = posts[index]
        guard let optionIndex = post.options.firstIndex(where: { $0.id == option.id }) else {
            return
        }
        
        post.options[optionIndex].voted += 1
        post.lastVoteAt = Date()
        
        let votedBy = VotedBy(
            user: currentUser!,
            postId: post.id,
            selectedOption: option
        )
        post.votedBys.append(votedBy)
        
        posts[index] = post
    }
}

// MARK: - State and Localization

extension PostViewModel {

    /// Localized strings used in the view model.
    private enum Localization {
        static let pageTitle = NSLocalizedString(
            "Discover",
            value: "Discover",
            comment: "Page title of Discover page"
        )
    }
}
