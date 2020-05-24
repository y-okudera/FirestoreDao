//
//  FirestoreDao.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import FirebaseFirestore

public final class FirestoreDao<Delegate: FirestoreDaoDelegate> {

    /// Callback
    ///
    /// - Note: Weak is not required here because the delegate instance is weak in AnyFirestoreDaoDelegate.
    public var delegate: AnyFirestoreDaoDelegate<Delegate>

    public init(delegate: AnyFirestoreDaoDelegate<Delegate>) {
        self.delegate = delegate
    }
}

// MARK: - Access a specific document.
public extension FirestoreDao {

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
                self.delegate.firestoreDao(self, creationResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(self, creationResult: .success(()))
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
                self.delegate.firestoreDao(self, updatingResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(self, updatingResult: .success(()))
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
                self.delegate.firestoreDao(self, fetchingResult: .failure(.detail(error)))
                return
            }
            guard let snapshotData = snapshot?.data() else {
                self.delegate.firestoreDao(self, fetchingResult: .failure(.snapshotDataNotFound))
                return
            }
            let model = Delegate.Model(documentPath: documentPath, data: snapshotData)
            self.delegate.firestoreDao(self, fetchingResult: .success(model))
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
                self.delegate.firestoreDao(self, deletionResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(self, deletionResult: .success(()))
        }
    }
}

public extension FirestoreDao {

    /// Fetch all documents.
    func fetchAllDocuments() {
        Firestore.firestore().collection(Delegate.Model.collectionPath).getDocuments { [weak self] snapshot, error in
            guard let `self` = self else {
                return
            }
            if let error = error {
                self.delegate.firestoreDao(self, allDocumentsFetchingResult: .failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                self.delegate.firestoreDao(self, allDocumentsFetchingResult: .failure(.snapshotDataNotFound))
                return
            }
            let models = snapshot.documents.map { Delegate.Model.init(documentPath: $0.documentID, data: $0.data()) }
            self.delegate.firestoreDao(self, allDocumentsFetchingResult: .success(models))
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
                self.delegate.firestoreDao(self, documentsFetchingResult: .failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                self.delegate.firestoreDao(self, documentsFetchingResult: .failure(.snapshotDataNotFound))
                return
            }
            let models = snapshot.documents.map { Delegate.Model.init(documentPath: $0.documentID, data: $0.data()) }
            self.delegate.firestoreDao(self, documentsFetchingResult: .success(models))
        }
    }
}

// MARK: - Access multiple documents.
public extension FirestoreDao {

    enum FirestoreDaoBatchOperationType {
        case set
        case update
        case delete
    }

    struct BatchOperator {
        public let model: Delegate.Model
        public let operationType: FirestoreDaoBatchOperationType

        public init(model: Delegate.Model, operationType: FirestoreDaoBatchOperationType) {
            self.model = model
            self.operationType = operationType
        }
    }

    /// A set of write operations on one or more documents.
    /// - Parameter batchOperators: Array of structures with data model and operation type.
    ///
    /// - Note: Batch of writes can write to a maximum of 500 documents. For additional limits related to writes,
    /// see [Quotas and Limits](https://firebase.google.com/docs/firestore/quotas#writes_and_transactions).
    func batch(batchOperators: [BatchOperator]) {
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
                self.delegate.firestoreDao(self, batchWritingResult: .failure(.detail(error)))
                return
            }
            self.delegate.firestoreDao(self, batchWritingResult: .success(()))
        }
    }
}
