//
//  FirestoreDaoDelegate.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

// MARK: - Protocol
public protocol FirestoreDaoDelegate: AnyObject {
    associatedtype Model: FirestoreModel

    // Access a specific document.

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, creationResult: Swift.Result<Void, FirestoreDaoWriteError>)

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, updatingResult: Swift.Result<Void, FirestoreDaoWriteError>)

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, fetchingResult: Swift.Result<Model, FirestoreDaoFetchError>)

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, deletionResult: Swift.Result<Void, FirestoreDaoWriteError>)

    // Access multiple documents.

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, allDocumentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>)

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, documentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>)

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, batchWritingResult: Swift.Result<Void, FirestoreDaoWriteError>)
}

// MARK: - Default impl
public extension FirestoreDaoDelegate {

    // Access a specific document.

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, creationResult: Swift.Result<Void, FirestoreDaoWriteError>) {}

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, updatingResult: Swift.Result<Void, FirestoreDaoWriteError>) {}

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, fetchingResult: Swift.Result<Model, FirestoreDaoFetchError>) {}

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, deletionResult: Swift.Result<Void, FirestoreDaoWriteError>) {}

    // Access multiple documents.

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, allDocumentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>) {}

    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, documentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>) {}
    
    func firestoreDao(_ firestoreDao: FirestoreDao<Self>, batchWritingResult: Swift.Result<Void, FirestoreDaoWriteError>) {}
}
