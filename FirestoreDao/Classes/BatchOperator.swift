//
//  BatchOperator.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/30.
//  Copyright © 2020 yuoku. All rights reserved.
//

public enum BatchOperationType {
    case set
    case update
    case delete
}

public struct BatchOperator<Model: FirestoreModel> {
    public let model: Model
    public let operationType: BatchOperationType

    public init(model: Model, operationType: BatchOperationType) {
        self.model = model
        self.operationType = operationType
    }
}
