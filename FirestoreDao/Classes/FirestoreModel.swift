//
//  FirestoreModel.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/24.
//  Copyright © 2020 yuoku. All rights reserved.
//

public protocol FirestoreModelKeys: MirrorableEnum {
    associatedtype FirestoreModelType
    var key: String { get }
}

public extension FirestoreModelKeys {
    var key: String {
        return mirror.label
    }
}

public protocol FirestoreModel {

    associatedtype Keys: FirestoreModelKeys

    /// A unique path for the collection.
    static var collectionPath: String { get }

    /// A unique path for the document in collection.
    var documentPath: String { get }

    init(documentPath: String, data: [String: Any])

    /// Get Dictionary for register new data in Firestore.
    ///
    /// - Note: Both 'createdAt' and 'updatedAt' to set serverTimestamp.
    var initialDictionary: [String: Any] { get }

    /// Get Dictionary for update the data in Firestore.
    ///
    /// - Note: 'createdAt' sets the saved value and 'updatedAt' sets serverTimestamp.
    var updateDictionary: [String: Any] { get }
}
