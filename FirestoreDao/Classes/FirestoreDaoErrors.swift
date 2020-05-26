//
//  FirestoreDaoErrors.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

public enum FirestoreDaoFetchError: Error {
    case snapshotDataNotFound
    case detail(Error)
}

public enum FirestoreDaoWriteError: Error {
    case detail(Error)
}
