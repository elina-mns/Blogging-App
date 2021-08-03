//
//  StorageManager.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() { }
    
    func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        guard let pngData = image?.pngData() else { return }
        
        container
            .reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func downloadURLForProfilePicture(user: User, completion: @escaping (URL?) -> Void) {
        
    }
    
    func uploadHeaderImage(post: BlogPost, image: UIImage, completion: @escaping (Bool) -> Void) {
        
    }
    
    func downloadURLForPostHeader(post: BlogPost, completion: @escaping (URL?) -> Void) {
        
    }
}

