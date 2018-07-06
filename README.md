# Sample iOS Swift consumer and ruby provider.
This is a demonstration project for using the [Swift Pact library](https://github.com/DiUS/pact-consumer-swift).

This fork contains an update for Xcode 9.4 and Swift 4.1 as well as replacing Carthage with CocoaPods.

### To build and run Pact Swift Tests
* Install the pact mock service gem (required for running the iOS Pact tests).
```
gem install pact-mock_service -v 0.9.0
```
*NB:* if you are using the system ruby, you will need to install the gem using sudo. Better options would be to use something like rbenv / rvm / chruby.

* Download and compile the iOS library dependencies:
```
CatKit $ pod install 
```
(Execute from the CatKit directory)

* Run the iOS unit tests. (can be done from within XCode if you prefer)
```
CatKit $ xcodebuild -workspace CatKit.xcworkspace -scheme CatKit clean test -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 8"
```

This will run the unit tests (Pact Tests). After the pact tests run successfully the generated pact files should live in the `CatKit/tmp/pacts/` directory. A log of the pact test interactions can be found here `CatKit/tmp/pact.log`. If the tests fail, try looking in here for details as to why.

### Verify the ruby server with the generated pact file
Copy over the generated pact file from the iOS project, to the ruby server.
```
catkit-server $ cp ../CatKit/tmp/pacts/catkit_ios_app-catkit_service.json pacts/ios-app/
```
Install the required gems
```
catkit-server $ bundle install
```
(Execute from the catkit-server directory)

Run the pact verification to verify that the server conforms to the CatKit client.
```
catkit-server $ bundle exec rake pact:verify
```

NB: to run the catkit-server:
```
catkit-server $ bundle exec rackup config.ru
```

# More reading
* [Swift Pact library](https://github.com/DiUS/pact-consumer-swift)
* The original pact library, with lots of background and guidelines [Pact](https://github.com/realestate-com-au/pact)
* The pact mock server that the Swift library uses under the hood [Pact mock service](https://github.com/bethesque/pact-mock_service)
* A pact broker for managing the generated pact files (so you don't have to manually copy them around!) [Pact broker](https://github.com/bethesque/pact_broker)
