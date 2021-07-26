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
    
    private let container = Storage.storage().reference()
    
    private init() { }
    
    func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    func downloadURLForProfilePicture(user: User, completion: @escaping (URL?) -> Void) {
        
    }
    
    func uploadHeaderImage(post: BlogPost, image: UIImage, completion: @escaping (Bool) -> Void) {
        
    }
    
    func downloadURLForPostHeader(post: BlogPost, completion: @escaping (URL?) -> Void) {
        
    }
}

