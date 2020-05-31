//
//  AnyFirestoreDataAccessDelegate.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

/// Type Erasure
public final class AnyFirestoreDataAccessDelegate<Delegate: FirestoreDataAccessDelegate> {

    private weak var delegate: Delegate?

    public init(delegate: Delegate) {
        self.delegate = delegate
    }

    // Access a specific document.

    public func firestoreDao(creationResult: FDResult<Void, FDWriteError>) {
        delegate?.firestoreDao(creationResult: creationResult)
    }

    public func firestoreDao(updatingResult: FDResult<Void, FDWriteError>) {
        delegate?.firestoreDao(updatingResult: updatingResult)
    }

    public func firestoreDao(fetchingResult: FDResult<FetchResponse<Delegate.Model>, FDFetchError>) {
        delegate?.firestoreDao(fetchingResult: fetchingResult)
    }

    public func firestoreDao(deletionResult: FDResult<Void, FDWriteError>) {
        delegate?.firestoreDao(deletionResult: deletionResult)
    }

    // Access multiple documents.

    public func firestoreDao(allDocumentsFetchingResult: FDResult<[FetchResponse<Delegate.Model>], FDFetchError>) {
        delegate?.firestoreDao(allDocumentsFetchingResult: allDocumentsFetchingResult)
    }

    public func firestoreDao(documentsFetchingResult: FDResult<[FetchResponse<Delegate.Model>], FDFetchError>) {
        delegate?.firestoreDao(documentsFetchingResult: documentsFetchingResult)
    }

    public func firestoreDao(prefixSearchingResult: FDResult<[FetchResponse<Delegate.Model>], FDFetchError>) {
        delegate?.firestoreDao(prefixSearchingResult: prefixSearchingResult)
    }

    public func firestoreDao(batchWritingResult: FDResult<Void, FDWriteError>) {
        delegate?.firestoreDao(batchWritingResult: batchWritingResult)
    }
}
