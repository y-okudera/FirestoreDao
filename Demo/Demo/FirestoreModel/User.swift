//
//  User.swift
//  Demo
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirestoreDao

/// Firestore field model sample
struct User: FirestoreModel {
    static let collectionPath: String = "user"
    let documentPath: String

    let userID: String
    let userName: String
    let content: String
    let backImage: String?
    let iconImage: String?
    let createdAt: Timestamp
    let updatedAt: Timestamp

    init(documentPath: String, data: [String: Any]) {
        self.documentPath = documentPath
        self.userID = data[Keys.userID.key] as! String
        self.userName = data[Keys.userName.key] as! String
        self.content = data[Keys.content.key] as! String
        self.backImage = data[Keys.backImage.key] as? String
        self.iconImage = data[Keys.iconImage.key] as? String
        self.createdAt = data[Keys.createdAt.key] as? Timestamp ?? Timestamp()
        self.updatedAt = data[Keys.updatedAt.key] as? Timestamp ?? Timestamp()
    }

    /// Initializer for new data.
    init(uid: String, name: String) {
        let userData: [String: Any] = [
            Keys.userID.key: uid,
            Keys.userName.key: name,
            Keys.content.key: "",
            Keys.createdAt.key: Timestamp(),
            Keys.updatedAt.key: Timestamp()
        ]
        self = .init(documentPath: uid, data: userData)
    }

    /// Initializer for update data.
    init(oldUserData: User, content: String, iconImageUrl: URL?, backImageUrl: URL?) {
        let iconImageUrlString = iconImageUrl?.absoluteString ?? ""
        let backImageUrlString = backImageUrl?.absoluteString ?? ""

        var userData: [String: Any] = [
            Keys.userID.key: oldUserData.userID,
            Keys.userName.key: oldUserData.userName,
            Keys.content.key: content,
            Keys.createdAt.key: oldUserData.createdAt,
            Keys.updatedAt.key: oldUserData.updatedAt
        ]
        if !iconImageUrlString.isEmpty {
            userData[Keys.iconImage.key] = iconImageUrlString
        }
        if !backImageUrlString.isEmpty {
            userData[Keys.backImage.key] = backImageUrlString
        }
        self = .init(documentPath: oldUserData.userID, data: userData)
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
            Keys.userID.key: userID,
            Keys.userName.key: userName,
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

extension User {

    /// User properties key
    enum Keys: FirestoreModelKeys {

        typealias FirestoreModelType = Demo.User

        case content
        case backImage
        case iconImage
        case userID
        case userName
        case createdAt
        case updatedAt

        var key: String {
            return self.mirror.label
        }
    }
}
