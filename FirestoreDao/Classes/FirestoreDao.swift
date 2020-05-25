//
//  FirestoreDao.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import FirebaseFirestore

public final class FirestoreDao {

    public enum FirestoreDaoBatchOperationType {
        case set
        case update
        case delete
    }

    public struct BatchOperator<Model: FirestoreModel> {
        public let model: Model
        public let operationType: FirestoreDaoBatchOperationType

        public init(model: Model, operationType: FirestoreDaoBatchOperationType) {
            self.model = model
            self.operationType = operationType
        }
    }
}

// MARK: - Access a specific document.
public extension FirestoreDao {

    /// Create a new document.
    /// - Parameters:
    ///   - model: The structure to register.
    ///   - completionHandler: completion handler
    static func createDocument<Model: FirestoreModel>(model: Model, completionHandler: @escaping (Result<Void, FirestoreDaoWriteError>) -> Void) {
        let document = Firestore.firestore().collection(Model.collectionPath).document(model.documentPath)
        document.setData(model.initialDictionary) { error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            completionHandler(.success(()))
        }
    }

    /// Update a specific document.
    /// - Parameters:
    ///   - model: The structure to update.
    ///   - completionHandler: completion handler
    static func updateDocument<Model: FirestoreModel>(model: Model, completionHandler: @escaping (Result<Void, FirestoreDaoWriteError>) -> Void) {
        let document = Firestore.firestore().collection(Model.collectionPath).document(model.documentPath)
        document.updateData(model.updateDictionary) { error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            completionHandler(.success(()))
        }
    }

    /// Fetch a specific document.
    /// - Parameters:
    ///   - documentPath: A unique path for the document.
    ///   - completionHandler: completion handler
    static func fetchDocument<Model: FirestoreModel>(documentPath: String, completionHandler: @escaping (Result<Model, FirestoreDaoFetchError>) -> Void) {
        Firestore.firestore().collection(Model.collectionPath).document(documentPath).getDocument { snapshot, error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            guard let snapshotData = snapshot?.data() else {
                completionHandler(.failure(.snapshotDataNotFound))
                return
            }
            let model = Model(documentPath: documentPath, data: snapshotData)
            completionHandler(.success(model))
        }
    }

    /// Delete a specific document.
    /// - Parameters:
    ///   - documentPath: A unique path for the document.
    ///   - completionHandler: completion handler
    static func deleteDocument<Model: FirestoreModel>(modelType: Model.Type, documentPath: String, completionHandler: @escaping (Result<Void, FirestoreDaoWriteError>) -> Void) {
        let document = Firestore.firestore().collection(Model.collectionPath).document(documentPath)
        document.delete { error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            completionHandler(.success(()))
        }
    }
}

public extension FirestoreDao {

    /// Fetch all documents.
    /// - Parameters:
    ///   - completionHandler: completion handler
    static func fetchAllDocuments<Model: FirestoreModel>(completionHandler: @escaping (Result<[Model], FirestoreDaoFetchError>) -> Void) {
        Firestore.firestore().collection(Model.collectionPath).getDocuments { snapshot, error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                completionHandler(.failure(.snapshotDataNotFound))
                return
            }
            let models = snapshot.documents.map { Model(documentPath: $0.documentID, data: $0.data()) }
            completionHandler(.success(models))
        }
    }

    /// Fetch multiple documents.
    /// - Parameters:
    ///   - completionHandler: completion handler
    static func fetchDocuments<Model: FirestoreModel>(query: (FirestoreDaoQueryManager<Model>) -> Query = { $0.query },
                                                      completionHandler: @escaping (Result<[Model], FirestoreDaoFetchError>) -> Void) {
        let collectionReference = Firestore.firestore().collection(Model.collectionPath)
        let manager = FirestoreDaoQueryManager<Model>(query: collectionReference)
        query(manager).getDocuments { snapshot, error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                completionHandler(.failure(.snapshotDataNotFound))
                return
            }
            let models = snapshot.documents.map { Model(documentPath: $0.documentID, data: $0.data()) }
            completionHandler(.success(models))
        }
    }
}

// MARK: - Access multiple documents.
public extension FirestoreDao {

    /// A set of write operations on one or more documents.
    /// - Parameters:
    ///   - batchOperators: Array of structures with data model and operation type.
    ///   - completionHandler: completion handler
    ///
    /// - Note: Batch of writes can write to a maximum of 500 documents. For additional limits related to writes,
    /// see [Quotas and Limits](https://firebase.google.com/docs/firestore/quotas#writes_and_transactions).
    static func batch<Model: FirestoreModel>(batchOperators: [FirestoreDao.BatchOperator<Model>], completionHandler: @escaping (Result<Void, FirestoreDaoWriteError>) -> Void) {
        let batch = Firestore.firestore().batch()

        batchOperators.forEach {
            let document = Firestore.firestore().collection(Model.collectionPath).document($0.model.documentPath)

            switch $0.operationType {
            case .set:
                batch.setData($0.model.initialDictionary, forDocument: document)
            case .update:
                batch.updateData($0.model.updateDictionary, forDocument: document)
            case .delete:
                batch.deleteDocument(document)
            }
        }

        batch.commit { error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            completionHandler(.success(()))
        }
    }
}
