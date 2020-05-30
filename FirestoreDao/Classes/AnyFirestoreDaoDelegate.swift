//
//  AnyFirestoreDaoDelegate.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

/// Type Erasure
public final class AnyFirestoreDaoDelegate<Delegate: FirestoreDaoDelegate> {

    private weak var delegate: Delegate?

    public init(delegate: Delegate) {
        self.delegate = delegate
    }

    // Access a specific document.

    public func firestoreDao(creationResult: Swift.Result<Void, WriteError>) {
        delegate?.firestoreDao(creationResult: creationResult)
    }

    public func firestoreDao(updatingResult: Swift.Result<Void, WriteError>) {
        delegate?.firestoreDao(updatingResult: updatingResult)
    }

    public func firestoreDao(fetchingResult: Swift.Result<FetchResponse<Delegate.Model>, FetchError>) {
        delegate?.firestoreDao(fetchingResult: fetchingResult)
    }

    public func firestoreDao(deletionResult: Swift.Result<Void, WriteError>) {
        delegate?.firestoreDao(deletionResult: deletionResult)
    }

    // Access multiple documents.

    public func firestoreDao(allDocumentsFetchingResult: Swift.Result<[FetchResponse<Delegate.Model>], FetchError>) {
        delegate?.firestoreDao(allDocumentsFetchingResult: allDocumentsFetchingResult)
    }

    public func firestoreDao(documentsFetchingResult: Swift.Result<[FetchResponse<Delegate.Model>], FetchError>) {
        delegate?.firestoreDao(documentsFetchingResult: documentsFetchingResult)
    }

    public func firestoreDao(prefixSearchingResult: Swift.Result<[FetchResponse<Delegate.Model>], FetchError>) {
        delegate?.firestoreDao(prefixSearchingResult: prefixSearchingResult)
    }

    public func firestoreDao(batchWritingResult: Swift.Result<Void, WriteError>) {
        delegate?.firestoreDao(batchWritingResult: batchWritingResult)
    }
}
