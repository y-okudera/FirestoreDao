//
//  AnyFirestoreDaoDelegate.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

/// Type Erasure
public final class AnyFirestoreDaoDelegate<Delegate: FirestoreDaoDelegate> {

    private weak var delegate: Delegate?

    public init(delegate: Delegate) {
        self.delegate = delegate
    }

    // Access a specific document.

    public func firestoreDao(creationResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(creationResult: creationResult)
    }

    public func firestoreDao(updatingResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(updatingResult: updatingResult)
    }

    public func firestoreDao(fetchingResult: Swift.Result<Delegate.Model, FirestoreDaoFetchError>) {
        delegate?.firestoreDao(fetchingResult: fetchingResult)
    }

    public func firestoreDao(deletionResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(deletionResult: deletionResult)
    }

    // Access multiple documents.

    public func firestoreDao(allDocumentsFetchingResult: Swift.Result<[Delegate.Model], FirestoreDaoFetchError>) {
        delegate?.firestoreDao(allDocumentsFetchingResult: allDocumentsFetchingResult)
    }

    public func firestoreDao(documentsFetchingResult: Swift.Result<[Delegate.Model], FirestoreDaoFetchError>) {
        delegate?.firestoreDao(documentsFetchingResult: documentsFetchingResult)
    }

    public func firestoreDao(batchWritingResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(batchWritingResult: batchWritingResult)
    }
}
