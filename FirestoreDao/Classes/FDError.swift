//
//  FDError.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

public protocol FDError: Error {}

public enum FDFetchError: FDError {
    case snapshotDataNotFound
    case detail(Error)
}

public enum FDWriteError: FDError {
    case detail(Error)
}
