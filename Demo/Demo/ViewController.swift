//
//  ViewController.swift
//  Demo
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import FirebaseFirestore
import FirestoreDao
import UIKit

final class ViewController: UIViewController {

    lazy var userDao: FirestoreDao<ViewController> = {
        return FirestoreDao(delegate: AnyFirestoreDaoDelegate(delegate: self))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create new document.
        userDao.createDocument(model: .init(uid: "100", name: "Strawberry"))
        userDao.createDocument(model: .init(uid: "200", name: "Peach"))
        userDao.createDocument(model: .init(uid: "300", name: "Orange"))
        userDao.createDocument(model: .init(uid: "400", name: "Grape"))
        userDao.createDocument(model: .init(uid: "500", name: "Apple"))
    }
}

extension ViewController: FirestoreDaoDelegate {

    typealias Model = User

    func firestoreDao(_ firestoreDao: FirestoreDao<ViewController>, creationResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        switch creationResult {
        case .success:
            print("create succeeded.")

            // fetch
            firestoreDao.fetchDocument(documentPath: "100")
        case .failure(let error):
            print(error)
        }
    }

    func firestoreDao(_ firestoreDao: FirestoreDao<ViewController>, updatingResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        switch updatingResult {
        case .success:
            print("update succeeded.")

            // delete
            firestoreDao.deleteDocument(documentPath: "200")
        case .failure(let error):
            print(error)
        }
    }

    func firestoreDao(_ firestoreDao: FirestoreDao<ViewController>, fetchingResult: Swift.Result<User, FirestoreDaoFetchError>) {
        switch fetchingResult {
        case .success(let user):
            print("fetch succeeded: \(user)")

            let updatedUser = User(oldUserData: user,
                                   content: "updated!",
                                   iconImageUrl: URL(string: "https://via.placeholder.com/200x100"),
                                   backImageUrl: URL(string: "https://via.placeholder.com/300.png/09f/fff"))
            // update
            firestoreDao.updateDocument(model: updatedUser)
        case .failure(let error):
            print(error)
        }
    }

    func firestoreDao(_ firestoreDao: FirestoreDao<ViewController>, deletionResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        switch deletionResult {
        case .success:
            print("delete succeeded.")

            // fetch all documents
            firestoreDao.fetchAllDocuments()
        case .failure(let error):
            print(error)
        }
    }

    func firestoreDao(_ firestoreDao: FirestoreDao<ViewController>, allDocumentsFetchingResult: Result<[User], FirestoreDaoFetchError>) {
        switch allDocumentsFetchingResult {
        case .success(let users):
            print("all data fetching succeeded: \(users)")

            // fetch multiple documents
            firestoreDao.fetchDocuments { queryManager -> Query in
                queryManager.where(field: .userID, isGreaterThanOrEqualTo: "300")
                queryManager.limit(to: 2)
                return queryManager.query
            }
        case .failure(let error):
            print(error)
        }
    }

    func firestoreDao(_ firestoreDao: FirestoreDao<ViewController>, documentsFetchingResult: Result<[User], FirestoreDaoFetchError>) {
        switch documentsFetchingResult {
        case .success(let users):
            print("multiple data fetching succeeded: \(users)")

            var updatedUsers = [User]()
            for (index, user) in users.enumerated() {
                updatedUsers.append(.init(oldUserData: user, content: "updated!(\(index))", iconImageUrl: nil, backImageUrl: nil))
            }
            var batchOperators = updatedUsers.map { FirestoreDao<ViewController>.BatchOperator(model: $0, operationType: .update) }
            batchOperators.append(.init(model: .init(uid: "600", name: "Banana"), operationType: .set))
            // batch writing(update and create)
            firestoreDao.batch(batchOperators: batchOperators)
        case .failure(let error):
            print(error)
        }
    }

    func firestoreDao(_ firestoreDao: FirestoreDao<ViewController>, batchWritingResult: Result<Void, FirestoreDaoWriteError>) {
        switch batchWritingResult {
        case .success:
            print("batch writing succeeded.")
        case .failure(let error):
            print(error)
        }
    }
}
