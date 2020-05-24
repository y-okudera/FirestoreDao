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

    public func firestoreDao(_ firestoreDao: FirestoreDao<Delegate>, creationResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(firestoreDao, creationResult: creationResult)
    }

    public func firestoreDao(_ firestoreDao: FirestoreDao<Delegate>, updatingResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(firestoreDao, updatingResult: updatingResult)
    }

    public func firestoreDao(_ firestoreDao: FirestoreDao<Delegate>, fetchingResult: Swift.Result<Delegate.Model, FirestoreDaoFetchError>) {
        delegate?.firestoreDao(firestoreDao, fetchingResult: fetchingResult)
    }

    public func firestoreDao(_ firestoreDao: FirestoreDao<Delegate>, deletionResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(firestoreDao, deletionResult: deletionResult)
    }

    // Access multiple documents.

    public func firestoreDao(_ firestoreDao: FirestoreDao<Delegate>, allDocumentsFetchingResult: Swift.Result<[Delegate.Model], FirestoreDaoFetchError>) {
        delegate?.firestoreDao(firestoreDao, allDocumentsFetchingResult: allDocumentsFetchingResult)
    }

    public func firestoreDao(_ firestoreDao: FirestoreDao<Delegate>, documentsFetchingResult: Swift.Result<[Delegate.Model], FirestoreDaoFetchError>) {
        delegate?.firestoreDao(firestoreDao, documentsFetchingResult: documentsFetchingResult)
    }

    public func firestoreDao(_ firestoreDao: FirestoreDao<Delegate>, batchWritingResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        delegate?.firestoreDao(firestoreDao, batchWritingResult: batchWritingResult)
    }
}
