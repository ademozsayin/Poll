//
//  MockPostProvider.swift
//  PollexaTests
//
//  Created by Adem Özsayın on 8.06.2024.
//

import Foundation
import UIKit
import Pollexa
// MARK: - Mocks

class MockPostProvider: PostProviderProtocol, PostProviderType {
    
    static var shared: PostProviderType = MockPostProvider()

    var posts: [Post] = []
    var shouldFail = false
    
    init(posts: [Post] = [], shouldFail: Bool = false) {
        self.posts = posts
        self.shouldFail = shouldFail
    }
    
    func fetchAll(completion: @escaping (Result<[Post], Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.testError))
        } else {
            completion(.success(posts))
        }
    }
    
    enum MockError: Error {
        case testError
    }
}


// MARK: - Extensions

public extension Post {
    static func mockPost() -> Post {
        return Post(id: UUID().uuidString,
                    createdAt: Date(),
                    content: "Test",
                    options: [Option.mockOption(),Option.mockOption() ],
                    user: User(id: "1", username: "Pollexa", image: UIImage(named: "avatar_6")!),
                    votedBys: []
        )
        
    }
}
 extension Post.Option {
    static func mockOption(id: String = UUID().uuidString, imageName: String = "post_1_option_1", voted: Int = 0) -> Post.Option {
        guard let image = UIImage(named: imageName) else {
            fatalError("Failed to load image with name \(imageName)")
        }
        return Post.Option(id: id, image: image, voted: voted)
    }
}
