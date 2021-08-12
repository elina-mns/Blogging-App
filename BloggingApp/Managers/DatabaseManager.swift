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
    
    func addBlogPost(withPost post: BlogPost, email: String, completion: @escaping (Bool) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data: [String: Any] = [
            "id": post.id,
            "title": post.title,
            "body": post.text,
            "created": post.timestamp,
            "headerImageUrl": post.headerImageURL?.absoluteString ?? ""
        ]
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(post.id)
            .setData(data) { error in
                completion(error == nil)
            
        }
    }
    
    func getAllPosts(completion: @escaping ([BlogPost]) -> Void) {
        
    }
    
    func getAllPostsForUser(forEmail email: String, completion: @escaping ([BlogPost]) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0 .data() }),
                      error == nil else {
                    return
                }
                let posts: [BlogPost] = documents.compactMap({ dictionary in
                    
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let created = dictionary["created"] as? TimeInterval,
                          let headerImage = dictionary["headerImageUrl"] as? String else {
                        print("Invalid post fetch conversion")
                        return nil
                    }
                    let post = BlogPost(id: id, title: title, timestamp: created, headerImageURL: URL(string: headerImage), text: body)
                    return post
                })
                completion(posts)
            }
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
    
    func getUser(email: String, completion: @escaping (User?) -> Void) {
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(documentId)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                      error == nil else { return }
                
                let reference = data["profile_photo"]
                let user = User(name: name, email: email, profilePictureReference: reference)
                completion(user)
            }
    }
    
    func updateProfilePhoto(email: String, completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let photoReference = "profile_pictures/\(path)/photo.png"
        let databaseReference = database.collection("users").document(path)
        
        databaseReference.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else { return }
            data["profile_photo"] = photoReference
            databaseReference.setData(data) { error in
                completion(error == nil)
            }
        }
    }
}
