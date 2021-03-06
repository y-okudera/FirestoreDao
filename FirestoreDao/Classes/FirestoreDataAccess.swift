//
//  FirestoreDataAccess.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import FirebaseFirestore

public final class FirestoreDataAccess {

    // MARK: - Access a specific document.

    /// Create a new document.
    /// - Parameters:
    ///   - model: The structure to register.
    ///   - completionHandler: completion handler
    public static func createDocument<Model: FirestoreModel>(model: Model, completionHandler: @escaping (FDResult<Void, FDWriteError>) -> Void) {
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
    public static func updateDocument<Model: FirestoreModel>(model: Model, completionHandler: @escaping (FDResult<Void, FDWriteError>) -> Void) {
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
    public static func fetchDocument<Model: FirestoreModel>(documentPath: String, completionHandler: @escaping (FDResult<FetchResponse<Model>, FDFetchError>) -> Void) {
        Firestore.firestore().collection(Model.collectionPath).document(documentPath).getDocument { snapshot, error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                completionHandler(.failure(.snapshotDataNotFound))
                return
            }
            guard let snapshotData = snapshot.data() else {
                completionHandler(.failure(.snapshotDataNotFound))
                return
            }
            let model = FetchResponse<Model>(model: .init(documentPath: documentPath, data: snapshotData), snapshot: snapshot)
            completionHandler(.success(model))
        }
    }

    /// Delete a specific document.
    /// - Parameters:
    ///   - documentPath: A unique path for the document.
    ///   - completionHandler: completion handler
    public static func deleteDocument<Model: FirestoreModel>(modelType: Model.Type, documentPath: String, completionHandler: @escaping (FDResult<Void, FDWriteError>) -> Void) {
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

// MARK: - Access multiple documents.
public extension FirestoreDataAccess {

    /// Fetch all documents.
    /// - Parameters:
    ///   - completionHandler: completion handler
    static func fetchAllDocuments<Model: FirestoreModel>(completionHandler: @escaping (FDResult<[FetchResponse<Model>], FDFetchError>) -> Void) {
        Firestore.firestore().collection(Model.collectionPath).getDocuments { snapshot, error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                completionHandler(.failure(.snapshotDataNotFound))
                return
            }
            let response = snapshot.documents.map { FetchResponse<Model>(model: .init(documentPath: $0.documentID, data: $0.data()), snapshot: $0) }
            completionHandler(.success(response))
        }
    }

    /// Fetch multiple documents.
    /// - Parameters:
    ///   - completionHandler: completion handler
    static func fetchDocuments<Model: FirestoreModel>(query: (QueryManager<Model>) -> Query = { $0.query },
                                                      completionHandler: @escaping (FDResult<[FetchResponse<Model>], FDFetchError>) -> Void) {
        let collectionReference = Firestore.firestore().collection(Model.collectionPath)
        let manager = QueryManager<Model>(query: collectionReference)
        query(manager).getDocuments { snapshot, error in
            if let error = error {
                completionHandler(.failure(.detail(error)))
                return
            }
            guard let snapshot = snapshot else {
                completionHandler(.failure(.snapshotDataNotFound))
                return
            }
            let response = snapshot.documents.map { FetchResponse<Model>(model: .init(documentPath: $0.documentID, data: $0.data()), snapshot: $0) }
            completionHandler(.success(response))
        }
    }

    /// Search by prefix match.
    /// - Parameters:
    ///   - field: Field in the document
    ///   - searchWord: Search word
    ///   - limit: limit
    ///   - completionHandler: completion handler
    static func searchDocumentsByPrefixMatch<Model: FirestoreModel>(field: Model.Keys,
                                                                    searchWord: String,
                                                                    limit: Int?,
                                                                    completionHandler: @escaping (FDResult<[FetchResponse<Model>], FDFetchError>) -> Void) {
        self.fetchDocuments(query: { queryManager -> Query in
            queryManager.order(by: field, descending: false)
            queryManager.start(at: [searchWord])
            queryManager.end(at: [searchWord + "\u{f8ff}"])
            if let limit = limit {
                queryManager.limit(to: limit)
            }
            return queryManager.query
        }, completionHandler: { result in
            completionHandler(result)
        })
    }
}

public extension FirestoreDataAccess {

    /// A set of write operations on one or more documents.
    /// - Parameters:
    ///   - batchOperators: Array of structures with data model and operation type.
    ///   - completionHandler: completion handler
    ///
    /// - Note: Batch of writes can write to a maximum of 500 documents. For additional limits related to writes,
    /// see [Quotas and Limits](https://firebase.google.com/docs/firestore/quotas#writes_and_transactions).
    static func batch<Model: FirestoreModel>(batchOperators: [BatchOperator<Model>], completionHandler: @escaping (FDResult<Void, FDWriteError>) -> Void) {
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
