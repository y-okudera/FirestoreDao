//
//  Fruit.swift
//  Demo
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirestoreDao

/// Firestore field model sample
struct Fruit: FirestoreModel {
    static let collectionPath: String = "fruit"
    let documentPath: String

    let fruitID: String
    let name: String
    let content: String
    let backImage: String?
    let iconImage: String?
    let createdAt: Timestamp
    let updatedAt: Timestamp

    init(documentPath: String, data: [String: Any]) {
        self.documentPath = documentPath
        self.fruitID = data[Keys.fruitID.key] as! String
        self.name = data[Keys.name.key] as! String
        self.content = data[Keys.content.key] as! String
        self.backImage = data[Keys.backImage.key] as? String
        self.iconImage = data[Keys.iconImage.key] as? String
        self.createdAt = data[Keys.createdAt.key] as? Timestamp ?? Timestamp()
        self.updatedAt = data[Keys.updatedAt.key] as? Timestamp ?? Timestamp()
    }

    /// Initializer for new data.
    init(uid: String, name: String) {
        let fruitData: [String: Any] = [
            Keys.fruitID.key: uid,
            Keys.name.key: name,
            Keys.content.key: "",
            Keys.createdAt.key: Timestamp(),
            Keys.updatedAt.key: Timestamp()
        ]
        self = .init(documentPath: uid, data: fruitData)
    }

    /// Initializer for update data.
    init(oldFruitData: Fruit, content: String, iconImageUrl: URL?, backImageUrl: URL?) {
        let iconImageUrlString = iconImageUrl?.absoluteString ?? ""
        let backImageUrlString = backImageUrl?.absoluteString ?? ""

        var fruitData: [String: Any] = [
            Keys.fruitID.key: oldFruitData.fruitID,
            Keys.name.key: oldFruitData.name,
            Keys.content.key: content,
            Keys.createdAt.key: oldFruitData.createdAt,
            Keys.updatedAt.key: oldFruitData.updatedAt
        ]
        if !iconImageUrlString.isEmpty {
            fruitData[Keys.iconImage.key] = iconImageUrlString
        }
        if !backImageUrlString.isEmpty {
            fruitData[Keys.backImage.key] = backImageUrlString
        }
        self = .init(documentPath: oldFruitData.fruitID, data: fruitData)
    }

    var initialDictionary: [String: Any] {
        var dic = self.dictionaryWithoutTimestamp
        dic[Keys.createdAt.key] = FieldValue.serverTimestamp()
        dic[Keys.updatedAt.key] = FieldValue.serverTimestamp()
        return dic
    }

    var updateDictionary: [String: Any] {
        var dic = self.dictionaryWithoutTimestamp
        dic[Keys.createdAt.key] = self.createdAt
        dic[Keys.updatedAt.key] = FieldValue.serverTimestamp()
        return dic
    }

    private var dictionaryWithoutTimestamp: [String: Any] {
        var dic: [String: Any] = [
            Keys.fruitID.key: fruitID,
            Keys.name.key: name,
            Keys.content.key: content
        ]
        if let backImage = self.backImage {
            dic[Keys.backImage.key] = backImage
        }
        if let iconImage = self.iconImage {
            dic[Keys.iconImage.key] = iconImage
        }
        return dic
    }
}

extension Fruit {

    /// Fruit property keys
    enum Keys: FirestoreModelKeys {

        typealias FirestoreModelType = Demo.Fruit

        case content
        case backImage
        case iconImage
        case fruitID
        case name
        case createdAt
        case updatedAt

        var key: String {
            return self.mirror.label
        }
    }
}
