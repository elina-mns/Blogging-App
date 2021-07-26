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
        
    }
}
