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

    lazy var fruitDao: FirestoreDataAccess.DelegatableDao<ViewController> = {
        return .init(delegate: AnyFirestoreDataAccessDelegate(delegate: self))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func tappedCreateDataButton(_ sender: UIButton) {
        print("Create new document.")
        fruitDao.createDocument(model: .init(uid: "100", name: "Strawberry"))
        fruitDao.createDocument(model: .init(uid: "200", name: "Peach"))
        fruitDao.createDocument(model: .init(uid: "300", name: "Orange"))
        fruitDao.createDocument(model: .init(uid: "400", name: "Grape"))
        fruitDao.createDocument(model: .init(uid: "410", name: "Grapefruit"))
        fruitDao.createDocument(model: .init(uid: "500", name: "Apple"))
        fruitDao.createDocument(model: .init(uid: "510", name: "avocado"))

        // Use closure
//        FirestoreDataAccess.createDocument(model: Fruit(uid: "1000", name: "Muscat")) { result in
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
        fruitDao.fetchDocument(documentPath: "100")

        // Use closure
//        FirestoreDataAccess.fetchDocument(documentPath: "200") { (result: FDResult<FetchResponse<Fruit>, FDFetchError>) in
//            switch result {
//            case .success(let response):
//                print("Fetched data: \(response)")
//
//                print("Start updating fetched data.")
//                let updatedFruit = Fruit(oldFruitData: response.model,
//                                         content: "updated!",
//                                         iconImageUrl: URL(string: "https://via.placeholder.com/200x100"),
//                                         backImageUrl: URL(string: "https://via.placeholder.com/300.png/09f/fff"))
//                FirestoreDataAccess.updateDocument(model: updatedFruit) { result in
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
        fruitDao.deleteDocument(documentPath: "200")

        // Use closure
//        FirestoreDataAccess.deleteDocument(modelType: Fruit.self, documentPath: "200") { result in
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
        fruitDao.fetchAllDocuments()

        // Use closure
//        FirestoreDataAccess.fetchAllDocuments { (result: FDResult<[FetchResponse<Fruit>], FDFetchError>) in
//            switch result {
//            case .success(let response):
//                print("All data fetching succeeded. Count is \(response.count) :\(response)")
//            case .failure(let error):
//                print("All data fetching error: \(error)")
//            }
//        }
    }

    @IBAction private func tappedFetchMultipleDataButton(_ sender: UIButton) {
        print("Start Fetching multiple data.")
        fruitDao.fetchDocuments { queryManager -> Query in
            queryManager.where(field: .fruitID, isGreaterThanOrEqualTo: "300")
            queryManager.limit(to: 2)
            return queryManager.query
        }

        // Use closure
//        FirestoreDataAccess.fetchDocuments(query: { queryManager -> Query in
//            queryManager.where(field: .fruitID, isGreaterThanOrEqualTo: "300")
//            queryManager.limit(to: 2)
//            return queryManager.query
//
//        }, completionHandler: { (result: FDResult<[FetchResponse<Fruit>], FDFetchError>) in
//            switch result {
//            case .success(let response):
//                print("Multiple data fetching succeeded. Count is \(response.count) :\(response)")
//
//                print("Start batch writing(update and create)")
//                let models = response.map { $0.model }
//                var updatedFruits = [Fruit]()
//                for (index, model) in models.enumerated() {
//                    updatedFruits.append(.init(oldFruitData: model, content: "updated!(\(index))", iconImageUrl: nil, backImageUrl: nil))
//                }
//                var batchOperators = updatedFruits.map { BatchOperator(model: $0, operationType: .update) }
//                batchOperators.append(.init(model: .init(uid: "600", name: "Banana"), operationType: .set))
//
//                // Batch writing(update and create)
//                FirestoreDataAccess.batch(batchOperators: batchOperators) { result in
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

    @IBAction private func tappedSearchText_G_Button(_ sender: UIButton) {
        // Finds fruit data whose name begins with 'G' or 'g'.
        fruitDao.searchDocumentsByPrefixMatch(field: .name, searchWord: "G", limit: nil)

        // Use closure
//        FirestoreDataAccess.searchDocumentsByPrefixMatch(field: .name, searchWord: "G", limit: nil) { (result: FDResult<[FetchResponse<Fruit>], FDFetchError>) in
//            switch result {
//            case .success(let response):
//                print("Prefix searching succeeded. Count is \(response.count) :\(response)")
//            case .failure(let error):
//                print("Prefix searching error: \(error)")
//            }
//        }
    }
}

extension ViewController: FirestoreDataAccessDelegate {

    typealias Model = Fruit

    func firestoreDao(creationResult: FDResult<Void, FDWriteError>) {
        switch creationResult {
        case .success:
            print("Create succeeded.")

        case .failure(let error):
            print("Create error: \(error)")
        }
    }

    func firestoreDao(updatingResult: FDResult<Void, FDWriteError>) {
        switch updatingResult {
        case .success:
            print("Update succeeded.")

        case .failure(let error):
            print("Update error: \(error)")
        }
    }

    func firestoreDao(fetchingResult: FDResult<FetchResponse<Fruit>, FDFetchError>) {
        switch fetchingResult {
        case .success(let response):
            print("Fetch succeeded: \(response.model)")

            print("Start update fetched data.")
            let updatedFruit = Fruit(oldFruitData: response.model,
                                     content: "updated!",
                                     iconImageUrl: URL(string: "https://via.placeholder.com/200x100"),
                                     backImageUrl: URL(string: "https://via.placeholder.com/300.png/09f/fff"))
            // Update
            fruitDao.updateDocument(model: updatedFruit)

        case .failure(let error):
            print("Fetch error: \(error)")
        }
    }

    func firestoreDao(deletionResult: FDResult<Void, FDWriteError>) {
        switch deletionResult {
        case .success:
            print("Delete succeeded.")

        case .failure(let error):
            print("Delete error: \(error)")
        }
    }

    func firestoreDao(allDocumentsFetchingResult: FDResult<[FetchResponse<Fruit>], FDFetchError>) {
        switch allDocumentsFetchingResult {
        case .success(let response):
            print("All data fetching succeeded. Count is \(response.count) :\(response)")

        case .failure(let error):
            print("All data fetching error: \(error)")
        }
    }

    func firestoreDao(documentsFetchingResult: FDResult<[FetchResponse<Fruit>], FDFetchError>) {
        switch documentsFetchingResult {
        case .success(let response):
            print("Multiple data fetching succeeded. Count is \(response.count) :\(response)")

            print("Start batch writing(update and create)")
            var updatedFruits = [Fruit]()
            let models = response.map { $0.model }
            for (index, model) in models.enumerated() {
                updatedFruits.append(.init(oldFruitData: model, content: "updated!(\(index))", iconImageUrl: nil, backImageUrl: nil))
            }
            var batchOperators = updatedFruits.map { BatchOperator(model: $0, operationType: .update) }
            batchOperators.append(.init(model: .init(uid: "600", name: "Banana"), operationType: .set))

            // Batch writing(update and create)
            fruitDao.batch(batchOperators: batchOperators)
        case .failure(let error):
            print("Multiple data fetching error: \(error)")
        }
    }

    func firestoreDao(prefixSearchingResult: FDResult<[FetchResponse<Fruit>], FDFetchError>) {
        switch prefixSearchingResult {
        case .success(let response):
            print("Prefix searching succeeded. Count is \(response.count) :\(response)")
        case .failure(let error):
            print("Prefix searching error: \(error)")
        }
    }

    func firestoreDao(batchWritingResult: FDResult<Void, FDWriteError>) {
        switch batchWritingResult {
        case .success:
            print("Batch writing succeeded.")
        case .failure(let error):
            print(error)
        }
    }
}
