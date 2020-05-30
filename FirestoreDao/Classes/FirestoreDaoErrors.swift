//
//  FirestoreDaoErrors.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

public enum FetchError: Error {
    case snapshotDataNotFound
    case detail(Error)
}

public enum WriteError: Error {
    case detail(Error)
}
