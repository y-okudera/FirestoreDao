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

    lazy var userDao: FirestoreDao.DelegatableDao<ViewController> = {
        return .init(delegate: AnyFirestoreDaoDelegate(delegate: self))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func tappedCreateDataButton(_ sender: UIButton) {
        print("Create new document.")
        userDao.createDocument(model: .init(uid: "100", name: "Strawberry"))
        userDao.createDocument(model: .init(uid: "200", name: "Peach"))
        userDao.createDocument(model: .init(uid: "300", name: "Orange"))
        userDao.createDocument(model: .init(uid: "400", name: "Grape"))
        userDao.createDocument(model: .init(uid: "500", name: "Apple"))

        // Use closure
//        FirestoreDao.createDocument(model: User(uid: "1000", name: "Muscat")) { result in
//            switch result {
//            case .success:
//                print("データ登録に成功しました")
//            case .failure(let error):
//                print(error)
//            }
//        }
    }

    @IBAction private func tappedFetchDataButton(_ sender: UIButton) {
        print("Start Fetching data.")
        userDao.fetchDocument(documentPath: "100")

        // Use closure
//        FirestoreDao.fetchDocument(documentPath: "200") { (result: Swift.Result<User, FirestoreDaoFetchError>) in
//            switch result {
//            case .success(let user):
//                print("Fetched data: \(user)")
//
//                print("Start updating fetched data.")
//                let updatedUser = User(oldUserData: user,
//                                       content: "updated!",
//                                       iconImageUrl: URL(string: "https://via.placeholder.com/200x100"),
//                                       backImageUrl: URL(string: "https://via.placeholder.com/300.png/09f/fff"))
//                FirestoreDao.updateDocument(model: updatedUser) { result in
//                    switch result {
//                    case .success:
//                        print("Update succeeded.")
//                    case .failure(let error):
//                        print("Update error: \(error)")
//                    }
//                }
//            case .failure(let error):
//                print("Fetch error: \(error)")
//            }
//        }
    }

    @IBAction private func tappedDeleteDataButton(_ sender: UIButton) {
        print("Delete data.")
        userDao.deleteDocument(documentPath: "200")

        // Use closure
//        FirestoreDao.deleteDocument(modelType: User.self, documentPath: "200") { result in
//            switch result {
//            case .success:
//                print("Delete succeeded.")
//            case .failure(let error):
//                print("Delete error: \(error)")
//            }
//        }
    }

    @IBAction private func tappedFetchAllDataButton(_ sender: UIButton) {
        print("Start Fetching all data.")
        userDao.fetchAllDocuments()

        // Use closure
//        FirestoreDao.fetchAllDocuments { (result: Swift.Result<[User], FirestoreDaoFetchError>) in
//            switch result {
//            case .success(let users):
//                print("All data fetching succeeded. Count is \(users.count) :\(users)")
//            case .failure(let error):
//                print("All data fetching error: \(error)")
//            }
//        }
    }

    @IBAction private func tappedFetchMultipleDataButton(_ sender: UIButton) {
        print("Start Fetching multiple data.")
        userDao.fetchDocuments { queryManager -> Query in
            queryManager.where(field: .userID, isGreaterThanOrEqualTo: "300")
            queryManager.limit(to: 2)
            return queryManager.query
        }

        // Use closure
//        FirestoreDao.fetchDocuments(query: { queryManager -> Query in
//            queryManager.where(field: .userID, isGreaterThanOrEqualTo: "300")
//            queryManager.limit(to: 2)
//            return queryManager.query
//
//        }, completionHandler: { (result: Swift.Result<[User], FirestoreDaoFetchError>) in
//            switch result {
//            case .success(let users):
//                print("Multiple data fetching succeeded. Count is \(users.count) :\(users)")
//
//                print("Start batch writing(update and create)")
//                var updatedUsers = [User]()
//                for (index, user) in users.enumerated() {
//                    updatedUsers.append(.init(oldUserData: user, content: "updated!(\(index))", iconImageUrl: nil, backImageUrl: nil))
//                }
//                var batchOperators = updatedUsers.map { FirestoreDao.BatchOperator(model: $0, operationType: .update) }
//                batchOperators.append(.init(model: .init(uid: "600", name: "Banana"), operationType: .set))
//
//                // Batch writing(update and create)
//                FirestoreDao.batch(batchOperators: batchOperators) { result in
//                    switch result {
//                    case .success:
//                        print("Batch writing succeeded.")
//                    case .failure(let error):
//                        print("Batch writing error: \(error)")
//                    }
//                }
//
//            case .failure(let error):
//                print("Multiple data fetching error: \(error)")
//            }
//        })
    }
}

extension ViewController: FirestoreDaoDelegate {

    typealias Model = User

    func firestoreDao(creationResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        switch creationResult {
        case .success:
            print("Create succeeded.")

        case .failure(let error):
            print("Create error: \(error)")
        }
    }

    func firestoreDao(updatingResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        switch updatingResult {
        case .success:
            print("Update succeeded.")

        case .failure(let error):
            print("Update error: \(error)")
        }
    }

    func firestoreDao(fetchingResult: Swift.Result<User, FirestoreDaoFetchError>) {
        switch fetchingResult {
        case .success(let user):
            print("Fetch succeeded: \(user)")

            print("Start update fetched data.")
            let updatedUser = User(oldUserData: user,
                                   content: "updated!",
                                   iconImageUrl: URL(string: "https://via.placeholder.com/200x100"),
                                   backImageUrl: URL(string: "https://via.placeholder.com/300.png/09f/fff"))
            // Update
            userDao.updateDocument(model: updatedUser)

        case .failure(let error):
            print("Fetch error: \(error)")
        }
    }

    func firestoreDao(deletionResult: Swift.Result<Void, FirestoreDaoWriteError>) {
        switch deletionResult {
        case .success:
            print("Delete succeeded.")

        case .failure(let error):
            print("Delete error: \(error)")
        }
    }

    func firestoreDao(allDocumentsFetchingResult: Result<[User], FirestoreDaoFetchError>) {
        switch allDocumentsFetchingResult {
        case .success(let users):
            print("All data fetching succeeded. Count is \(users.count) :\(users)")

        case .failure(let error):
            print("All data fetching error: \(error)")
        }
    }

    func firestoreDao(documentsFetchingResult: Result<[User], FirestoreDaoFetchError>) {
        switch documentsFetchingResult {
        case .success(let users):
            print("Multiple data fetching succeeded. Count is \(users.count) :\(users)")

            print("Start batch writing(update and create)")
            var updatedUsers = [User]()
            for (index, user) in users.enumerated() {
                updatedUsers.append(.init(oldUserData: user, content: "updated!(\(index))", iconImageUrl: nil, backImageUrl: nil))
            }
            var batchOperators = updatedUsers.map { FirestoreDao.BatchOperator(model: $0, operationType: .update) }
            batchOperators.append(.init(model: .init(uid: "600", name: "Banana"), operationType: .set))

            // Batch writing(update and create)
            userDao.batch(batchOperators: batchOperators)
        case .failure(let error):
            print("Multiple data fetching error: \(error)")
        }
    }

    func firestoreDao(batchWritingResult: Result<Void, FirestoreDaoWriteError>) {
        switch batchWritingResult {
        case .success:
            print("Batch writing succeeded.")
        case .failure(let error):
            print(error)
        }
    }
}
