//
//  FirestoreDao+Delegatable.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import FirebaseFirestore

public extension FirestoreDao {

    final class DelegatableDao<Delegate: FirestoreDaoDelegate> {

        /// Callback
        ///
        /// - Note: Weak is not required here because the delegate instance is weak in AnyFirestoreDaoDelegate.
        public var delegate: AnyFirestoreDaoDelegate<Delegate>

        public init(delegate: AnyFirestoreDaoDelegate<Delegate>) {
            self.delegate = delegate
        }
    }
}

// MARK: - Access a specific document.
public extension FirestoreDao.DelegatableDao {

    /// Create a new document.
    /// - Parameters:
    ///   - model: The structure to register.
    func createDocument(model: Delegate.Model) {
        let document = Firestore.firestore().collection(Delegate.Model.collectionPath).document(model.documentPath)
        document.setData(model.initialDictionary) { [weak self] error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(creationResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(creationResult: .success(()))
        }
    }

    /// Update a specific document.
    /// - Parameters:
    ///   - model: The structure to update.
    func updateDocument(model: Delegate.Model) {
        let document = Firestore.firestore().collection(Delegate.Model.collectionPath).document(model.documentPath)
        document.updateData(model.updateDictionary) { [weak self] error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(updatingResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(updatingResult: .success(()))
        }
    }

    /// Fetch a specific document.
    /// - Parameter documentPath: A unique path for the document.
    func fetchDocument(documentPath: String) {
        Firestore.firestore().collection(Delegate.Model.collectionPath).document(documentPath).getDocument { [weak self] snapshot, error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(fetchingResult: .failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                self.delegate.firestoreDao(fetchingResult: .failure(.snapshotDataNotFound))
                return
            }
            guard let snapshotData = snapshot.data() else {
                self.delegate.firestoreDao(fetchingResult: .failure(.snapshotDataNotFound))
                return
            }
            let model = FirestoreDao.FetchResponse<Delegate.Model>(model: .init(documentPath: documentPath, data: snapshotData), snapshot: snapshot)
            self.delegate.firestoreDao(fetchingResult: .success(model))
        }
    }

    /// Delete a specific document.
    /// - Parameters:
    ///   - documentPath: A unique path for the document.
    func deleteDocument(documentPath: String) {
        let document = Firestore.firestore().collection(Delegate.Model.collectionPath).document(documentPath)
        document.delete { [weak self] error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(deletionResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(deletionResult: .success(()))
        }
    }
}

public extension FirestoreDao.DelegatableDao {

    /// Fetch all documents.
    func fetchAllDocuments() {
        Firestore.firestore().collection(Delegate.Model.collectionPath).getDocuments { [weak self] snapshot, error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(allDocumentsFetchingResult: .failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                self.delegate.firestoreDao(allDocumentsFetchingResult: .failure(.snapshotDataNotFound))
                return
            }
            let models = snapshot.documents.map { FirestoreDao.FetchResponse<Delegate.Model>(model: .init(documentPath: $0.documentID, data: $0.data()), snapshot: $0) }
            self.delegate.firestoreDao(allDocumentsFetchingResult: .success(models))
        }
    }

    /// Fetch multiple documents.
    func fetchDocuments(query: (FirestoreDaoQueryManager<Delegate.Model>) -> Query = { $0.query }) {
        let collectionReference = Firestore.firestore().collection(Delegate.Model.collectionPath)
        let manager = FirestoreDaoQueryManager<Delegate.Model>(query: collectionReference)
        query(manager).getDocuments { [weak self] snapshot, error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(documentsFetchingResult: .failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                self.delegate.firestoreDao(documentsFetchingResult: .failure(.snapshotDataNotFound))
                return
            }
            let models = snapshot.documents.map { FirestoreDao.FetchResponse<Delegate.Model>(model: .init(documentPath: $0.documentID, data: $0.data()), snapshot: $0) }
            self.delegate.firestoreDao(documentsFetchingResult: .success(models))
        }
    }

    /// Search by prefix match.
    /// - Parameters:
    ///   - field: Field in the document
    ///   - searchWord: Search word
    ///   - limit: limit
    func searchDocumentsByPrefixMatch(field: Delegate.Model.Keys, searchWord: String, limit: Int?) {

        let collectionReference = Firestore.firestore().collection(Delegate.Model.collectionPath)
        let manager = FirestoreDaoQueryManager<Delegate.Model>(query: collectionReference)
        manager.order(by: field, descending: false)
        manager.start(at: [searchWord])
        manager.end(at: [searchWord + "\u{f8ff}"])
        if let limit = limit {
            manager.limit(to: limit)
        }
        manager.query.getDocuments { [weak self] snapshot, error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(prefixSearchingResult: .failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                self.delegate.firestoreDao(prefixSearchingResult: .failure(.snapshotDataNotFound))
                return
            }
            let models = snapshot.documents.map { FirestoreDao.FetchResponse<Delegate.Model>(model: .init(documentPath: $0.documentID, data: $0.data()), snapshot: $0) }
            self.delegate.firestoreDao(prefixSearchingResult: .success(models))
        }
    }
}

// MARK: - Access multiple documents.
public extension FirestoreDao.DelegatableDao {

    /// A set of write operations on one or more documents.
    /// - Parameter batchOperators: Array of structures with data model and operation type.
    ///
    /// - Note: Batch of writes can write to a maximum of 500 documents. For additional limits related to writes,
    /// see [Quotas and Limits](https://firebase.google.com/docs/firestore/quotas#writes_and_transactions).
    func batch(batchOperators: [FirestoreDao.BatchOperator<Delegate.Model>]) {
        let batch = Firestore.firestore().batch()

        batchOperators.forEach {
            let document = Firestore.firestore().collection(Delegate.Model.collectionPath).document($0.model.documentPath)

            switch $0.operationType {
            case .set:
                batch.setData($0.model.initialDictionary, forDocument: document)
            case .update:
                batch.updateData($0.model.updateDictionary, forDocument: document)
            case .delete:
                batch.deleteDocument(document)
            }
        }

        batch.commit { [weak self] error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(batchWritingResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(batchWritingResult: .success(()))
        }
    }
}
