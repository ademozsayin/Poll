//
//  User.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

public struct User: Decodable, Equatable, Hashable, Identifiable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageName
    }
    
    // MARK: - Properties
    public let id: String
    public let username: String
    public let image: UIImage
    
    // MARK: - Life Cycle
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        
        let imageName = try container.decode(String.self, forKey: .imageName)
        
        if let image = UIImage(named: imageName) {
            self.image = image
        } else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: [CodingKeys.imageName],
                debugDescription: "An image with name \(imageName) could not be loaded from the bundle.")
            )
        }
    }   
    
    public init(id: String, username: String, image: UIImage) {
        self.id = id
        self.username = username
        self.image = image
    }
}
