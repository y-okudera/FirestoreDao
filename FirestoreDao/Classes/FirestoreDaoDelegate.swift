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

    func firestoreDao(creationResult: Swift.Result<Void, FirestoreDaoWriteError>)

    func firestoreDao(updatingResult: Swift.Result<Void, FirestoreDaoWriteError>)

    func firestoreDao(fetchingResult: Swift.Result<Model, FirestoreDaoFetchError>)

    func firestoreDao(deletionResult: Swift.Result<Void, FirestoreDaoWriteError>)

    // Access multiple documents.

    func firestoreDao(allDocumentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>)

    func firestoreDao(documentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>)

    func firestoreDao(batchWritingResult: Swift.Result<Void, FirestoreDaoWriteError>)
}

// MARK: - Default impl
public extension FirestoreDaoDelegate {

    // Access a specific document.

    func firestoreDao(creationResult: Swift.Result<Void, FirestoreDaoWriteError>) {}

    func firestoreDao(updatingResult: Swift.Result<Void, FirestoreDaoWriteError>) {}

    func firestoreDao(fetchingResult: Swift.Result<Model, FirestoreDaoFetchError>) {}

    func firestoreDao(deletionResult: Swift.Result<Void, FirestoreDaoWriteError>) {}

    // Access multiple documents.

    func firestoreDao(allDocumentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>) {}

    func firestoreDao(documentsFetchingResult: Swift.Result<[Model], FirestoreDaoFetchError>) {}
    
    func firestoreDao(batchWritingResult: Swift.Result<Void, FirestoreDaoWriteError>) {}
}
