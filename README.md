# FirestoreDao
FirestoreDao is Cloud Firestore wrapper library.

[![Version](https://img.shields.io/cocoapods/v/FirestoreDao.svg?style=flat)](http://cocoapods.org/pods/FirestoreDao)
[![License](https://img.shields.io/cocoapods/l/FirestoreDao.svg?style=flat)](http://cocoapods.org/pods/FirestoreDao)
[![Platform](https://img.shields.io/cocoapods/p/FirestoreDao.svg?style=flat)](http://cocoapods.org/pods/FirestoreDao)

## Usage

To run the demo project, clone the repo, and run `pod install` from the Demo directory first.

FirestoreDao provides the interface for operating Firestore.
The interface is a delegate or closure.

If you want one class to access one field, we recommend using delegates.
Use closures when you want to access multiple fields from one class.

## Requirements

- iOS 11.0+
- Xcode 11+
- Swift 5.1+

## Installation

FirestoreDao library has a dependency on 'Firebase/Firestore',
so it is recommended to install it with CocoaPods.

FirestoreDao is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FirestoreDao"
```

## Author

Yuki Okudera, appledev.yuoku@gmail.com

## License

FirestoreDao is available under the MIT license. See the LICENSE file for more info.
