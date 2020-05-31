Pod::Spec.new do |s|
  s.name             = 'FirestoreDao'
  s.version          = '0.0.5'
  s.summary          = 'FirebaseFirestore wrapper library.'
  s.description      = <<-DESC
It is wrapper library for easy use of firestore.
                       DESC

  s.homepage         = 'https://github.com/y-okudera/FirestoreDao'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YukiOkudera' => 'appledev.yuoku@gmail.com' }
  s.source           = { :git => 'https://github.com/y-okudera/FirestoreDao.git', :tag => s.version.to_s }

  s.swift_version = '5.1'
  s.ios.deployment_target = '11.0'
  s.source_files = 'FirestoreDao/Classes/*.swift'
  s.static_framework = true
  s.dependency 'Firebase/Firestore'

end
