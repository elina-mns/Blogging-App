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
    
    private let database = Storage.storage()
    
    private init() { }
}

