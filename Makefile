bootstrap:
	gem install bundler -v 2.1.4
	bundle install
	# pod install
	bundle exec pod keys set BaseAPIURL "https://cdn.jsdelivr.net/gh/polydice/iCook-tvOS@gh-pages/demo/"
	bundle exec pod keys set CrashlyticsAPIKey "API_KEY"
	bundle exec pod keys set TreasureDataAPIKey "API_KEY"
	bundle exec pod install
	# sh scripts/fabric.sh
	mkdir -p keys
	touch keys/fabric.apikey && echo "fabric.apikey" > keys/fabric.apikey
	touch keys/fabric.buildsecret && echo "fabric.buildsecret" > keys/fabric.buildsecret
