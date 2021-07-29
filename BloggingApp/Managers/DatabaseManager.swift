//
//  DatabaseManager.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() { }
    
    func addBlogPost(withPost post: BlogPost, user: User, completion: @escaping (Bool) -> Void) {
    
    }
    
    func getAllPosts(completion: @escaping ([BlogPost]) -> Void) {
        
    }
    
    func getAllPostsForUser(forUser user: User, completion: @escaping ([BlogPost]) -> Void) {
        
    }
    
    func addUser(user: User, completion: @escaping (Bool) -> Void) {
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email": user.email,
            "name": user.name
        ]
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
            completion(error == nil)
        }
    }
}
