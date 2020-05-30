//
//  MirrorableEnum.swift
//  FirestoreDao
//
//  Created by okudera on 2020/05/25.
//  Copyright © 2020 yuoku. All rights reserved.
//

public protocol MirrorableEnum {}

public extension MirrorableEnum {
    var mirror: (label: String, params: [String: Any]) {
        get {
            let reflection = Mirror(reflecting: self)
            guard reflection.displayStyle == .enum,
                let associated = reflection.children.first else {
                    return ("\(self)", [:])
            }
            let values = Mirror(reflecting: associated.value).children
            var valuesArray = [String: Any]()
            for case let item in values where item.label != nil {
                valuesArray[item.label!] = item.value
            }
            return (associated.label!, valuesArray)
        }
    }
}
