//
//  FetchResponse.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/30.
//  Copyright © 2020 yuoku. All rights reserved.
//

import FirebaseFirestore

public struct FetchResponse<Model: FirestoreModel> {
    public let model: Model
    public let snapshot: DocumentSnapshot

    public init(model: Model, snapshot: DocumentSnapshot) {
        self.model = model
        self.snapshot = snapshot
    }
}
