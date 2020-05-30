//
//  FirestoreDaoDelegate.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

// MARK: - Protocol
public protocol FirestoreDaoDelegate: AnyObject {
    associatedtype Model: FirestoreModel

    // Access a specific document.

    func firestoreDao(creationResult: Swift.Result<Void, WriteError>)

    func firestoreDao(updatingResult: Swift.Result<Void, WriteError>)

    func firestoreDao(fetchingResult: Swift.Result<FetchResponse<Model>, FetchError>)

    func firestoreDao(deletionResult: Swift.Result<Void, WriteError>)

    // Access multiple documents.

    func firestoreDao(allDocumentsFetchingResult: Swift.Result<[FetchResponse<Model>], FetchError>)

    func firestoreDao(documentsFetchingResult: Swift.Result<[FetchResponse<Model>], FetchError>)

    func firestoreDao(prefixSearchingResult: Swift.Result<[FetchResponse<Model>], FetchError>)

    func firestoreDao(batchWritingResult: Swift.Result<Void, WriteError>)
}

// MARK: - Default impl
public extension FirestoreDaoDelegate {

    // Access a specific document.

    func firestoreDao(creationResult: Swift.Result<Void, WriteError>) {}

    func firestoreDao(updatingResult: Swift.Result<Void, WriteError>) {}

    func firestoreDao(fetchingResult: Swift.Result<FetchResponse<Model>, FetchError>) {}

    func firestoreDao(deletionResult: Swift.Result<Void, WriteError>) {}

    // Access multiple documents.

    func firestoreDao(allDocumentsFetchingResult: Swift.Result<[FetchResponse<Model>], FetchError>) {}

    func firestoreDao(documentsFetchingResult: Swift.Result<[FetchResponse<Model>], FetchError>) {}

    func firestoreDao(prefixSearchingResult: Swift.Result<[FetchResponse<Model>], FetchError>) {}
    
    func firestoreDao(batchWritingResult: Swift.Result<Void, WriteError>) {}
}
