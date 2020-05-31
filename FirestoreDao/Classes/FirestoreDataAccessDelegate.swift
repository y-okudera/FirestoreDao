//
//  FirestoreDataAccessDelegate.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

public protocol FirestoreDataAccessDelegate: AnyObject {
    associatedtype Model: FirestoreModel

    // Access a specific document.

    func firestoreDao(creationResult: FDResult<Void, FDWriteError>)

    func firestoreDao(updatingResult: FDResult<Void, FDWriteError>)

    func firestoreDao(fetchingResult: FDResult<FetchResponse<Model>, FDFetchError>)

    func firestoreDao(deletionResult: FDResult<Void, FDWriteError>)

    // Access multiple documents.

    func firestoreDao(allDocumentsFetchingResult: FDResult<[FetchResponse<Model>], FDFetchError>)

    func firestoreDao(documentsFetchingResult: FDResult<[FetchResponse<Model>], FDFetchError>)

    func firestoreDao(prefixSearchingResult: FDResult<[FetchResponse<Model>], FDFetchError>)

    func firestoreDao(batchWritingResult: FDResult<Void, FDWriteError>)
}

// MARK: - Default impl
public extension FirestoreDataAccessDelegate {

    // Access a specific document.

    func firestoreDao(creationResult: FDResult<Void, FDWriteError>) {}

    func firestoreDao(updatingResult: FDResult<Void, FDWriteError>) {}

    func firestoreDao(fetchingResult: FDResult<FetchResponse<Model>, FDFetchError>) {}

    func firestoreDao(deletionResult: FDResult<Void, FDWriteError>) {}

    // Access multiple documents.

    func firestoreDao(allDocumentsFetchingResult: FDResult<[FetchResponse<Model>], FDFetchError>) {}

    func firestoreDao(documentsFetchingResult: FDResult<[FetchResponse<Model>], FDFetchError>) {}

    func firestoreDao(prefixSearchingResult: FDResult<[FetchResponse<Model>], FDFetchError>) {}
    
    func firestoreDao(batchWritingResult: FDResult<Void, FDWriteError>) {}
}
