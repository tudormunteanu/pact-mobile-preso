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

If running the tests from Xcode and use **rvm**, follow the next steps:

1. Open the current Xcode Schema and under Test, click on "Pre-actions".
2. For Shell enter "/bin/bash".
3. In the script area enter:

```
	source ~/.bash_profile
	rvm use 2.3.1
	"$SRCROOT"/Pods/PactConsumerSwift/scripts/start_server.sh
```

4. For "Post-actions" add:

```
source ~/.bash_profile
rvm use 2.3.1
"$SRCROOT"/Pods/PactConsumerSwift/scripts/stop_server.sh
```

*NB:* This assumes that `bash` is available and RVM is setup from the `.bash_profile` file. You can change ruby version 2.3.1 to any version > 2.3.

### Verifying against a service

Use [pipenv](https://docs.pipenv.org/) to install `pact-python` by running:

	pip install pipenv
	pipenv install
	pipenv --python=3.7
	pipenv shell
	pip install pact-python

Next step is to check the generated .json against the server responses:

	CatKit $ pact-verifier --provider-base-url=<server_url> --pact-url=./tmp/pacts/ios-app-guacamole-mobile-bff.json 

Don't forget to change <server_url> to the server address you'd like to test.

# More reading
* [Publishing a Pack](https://github.com/pact-foundation/pact_broker/wiki/Publishing-and-retrieving-pacts)
* [Swift Pact library](https://github.com/DiUS/pact-consumer-swift)
* The original pact library, with lots of background and guidelines [Pact](https://github.com/realestate-com-au/pact)
* The pact mock server that the Swift library uses under the hood [Pact mock service](https://github.com/bethesque/pact-mock_service)
* A pact broker for managing the generated pact files (so you don't have to manually copy them around!) [Pact broker](https://github.com/bethesque/pact_broker)
