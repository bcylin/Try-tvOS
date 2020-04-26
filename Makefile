bootstrap:
	gem install bundler -v 2.1.4
	bundle install
	# pod install
	bundle exec pod keys set BaseAPIURL "https://cdn.jsdelivr.net/gh/polydice/iCook-tvOS@gh-pages/demo/"
	bundle exec pod keys set CrashlyticsAPIKey "API_KEY"
	bundle exec pod keys set TreasureDataAPIKey "API_KEY"
	bundle exec pod install
	# mock Google Services plist
	cp -n mock-GoogleService-Info.plist iCookTV/GoogleService-Info.plist
