//
//  FDResult.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/31.
//  Copyright © 2020 yuoku. All rights reserved.
//

public enum FDResult<Success, Failure> where Failure: FDError {
    case success(Success)
    case failure(Failure)
}
