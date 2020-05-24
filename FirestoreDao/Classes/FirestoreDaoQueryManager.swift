//
//  FirestoreDaoQueryManager.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

import FirebaseFirestore

public final class FirestoreDaoQueryManager<M: FirestoreModel> {

    public var query: Query

    public init(query: Query) {
        self.query = query
    }
}

// MARK: - Filtering Data
public extension FirestoreDaoQueryManager {
    /// `== value`
    func `where`(field: M.Keys, isEqualTo value: Any) {
        self.query = self.query.whereField(field.key, isEqualTo: value)
    }

    /// `< value`
    func `where`(field: M.Keys, isLessThan value: Any) {
        self.query = self.query.whereField(field.key, isLessThan: value)
    }

    /// `<= value`
    func `where`(field: M.Keys, isLessThanOrEqualTo value: Any) {
        self.query = self.query.whereField(field.key, isLessThanOrEqualTo: value)
    }

    /// `> value`
    func `where`(field: M.Keys, isGreaterThan value: Any) {
        self.query = self.query.whereField(field.key, isGreaterThan: value)
    }

    /// `>= value`
    func `where`(field: M.Keys, isGreaterThanOrEqualTo value: Any) {
        self.query = self.query.whereField(field.key, isGreaterThanOrEqualTo: value)
    }

    /// The specified field's value must equal one of the values from the provided array.
    func `where`(field: M.Keys, in values: [Any]) {
        self.query = self.query.whereField(field.key, in: values)
    }

    /// The specified field must be an array, and the array must contain the provided value.
    func `where`(field: M.Keys, arrayContains value: Any) {
        self.query = self.query.whereField(field.key, arrayContains: value)
    }
}

// MARK: - Filtering Data
public extension FirestoreDaoQueryManager {
    /// The first matching documents up to the specified number.
    func limit(to limit: Int) {
        self.query = self.query.limit(to: limit)
    }

    /// The last matching documents up to the specified number.
    func limit(toLast limit: Int) {
        self.query = self.query.limit(toLast: limit)
    }
}

// MARK: - Sorting data
public extension FirestoreDaoQueryManager {
    /// Sorted by the specified field.
    func order(by field: M.Keys, descending: Bool) {
        self.query = self.query.order(by: field.key, descending: descending)
    }
}

// MARK: - Choosing StartPoints
public extension FirestoreDaoQueryManager {
    /// Starts at the provided document (inclusive).
    /// The starting position is relative to the order of the query.
    /// The document must contain all of the fields provided in the orderBy of this query.
    func start(atDocument document: DocumentSnapshot) {
        self.query = self.query.start(atDocument: document)
    }

    /// Starts after the provided document (exclusive).
    /// The starting position is relative to the order of the query.
    /// The document must contain all of the fields provided in the orderBy of this query.
    func start(afterDocument document: DocumentSnapshot) {
        self.query = self.query.start(afterDocument: document)
    }
}
