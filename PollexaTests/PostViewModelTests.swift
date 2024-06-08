//
//  PostViewModelTests.swift
//  PollexaTests
//
//  Created by Adem Özsayın on 8.06.2024.
//

import XCTest
@testable import Pollexa

/**
 Unit tests for the PostViewModel class.
 */
final class PostViewModelTests: XCTestCase {
    
    var viewModel: PostViewModel!
    var mockPostProvider: MockPostProvider!
    
    override func setUp() {
        super.setUp()
        mockPostProvider = MockPostProvider()
        PostProvider.setShared(mockPostProvider)
        viewModel = PostViewModel(postProvider: mockPostProvider)
    }
    
    override func tearDown() {
        viewModel = nil
        mockPostProvider = nil
        super.tearDown()
    }
    
    /**
     Tests the initialization of the view model.
     */
    func testInitialization() {
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    /**
     Tests the fetching of posts with a successful result.
     */
    func testFetchPostsSuccess() async {
        await viewModel.fetchPosts()
        
        XCTAssertEqual(viewModel.postsViewModels.count, 7)
        
        do {
            try await Task.sleep(nanoseconds: UInt64(2.6 * 1_000_000_000))
            XCTAssertEqual(viewModel.state, .posts)
        } catch {
           
        }
    }
    
    /**
     Tests the voting functionality of the view model.
     */
    func testVote() {
        let post = Post.mockPost()
        viewModel.posts = [post]
        viewModel.buildPostViewModels()
        
        viewModel.currentUser = post.user!
        
        let indexPath = IndexPath(row: 0, section: 0)
        let option = post.options.first!
        
        viewModel.vote(at: option, indexPath: indexPath)
        
        XCTAssertEqual(viewModel.posts[0].options[0].voted, 1)
        XCTAssertTrue(viewModel.posts[0].votedBys.contains { $0.postId == post.id && $0.selectedOption.id == option.id })
    }
}
