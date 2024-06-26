//
//  PostOption.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

extension Post {
    
    public struct Option: Decodable, Hashable {
        
        // MARK: - Types
        enum CodingKeys: String, CodingKey {
            case id
            case imageName
            case voted
        }
        
        // MARK: - Properties
        public let id: String
        public let image: UIImage
        public var voted: Int
        
        
        // MARK: - Life Cycle
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            voted = try container.decode(Int.self, forKey: .voted)
            let imageName = try container.decode(
                String.self,
                forKey: .imageName
            )
            
            if let image = UIImage(named: imageName) {
                self.image = image
            } else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: [CodingKeys.imageName],
                    debugDescription: "An image with name \(imageName) could not be loaded from the bundle.")
                )
            }
        }
        
        // MARK: - Life Cycle
        public init(id: String, image: UIImage, voted: Int) {
            self.id = id
            self.image = image
            self.voted = voted
        }

    }    
}

