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
}
