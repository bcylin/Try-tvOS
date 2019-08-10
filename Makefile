bootstrap:
	gem install bundler -v 2.0.2
	bundle install
	# pod install
	bundle exec pod keys set BaseAPIURL "https://bcyl.in/Try-tvOS/demo/"
	# "https://polydice.com/iCook-tvOS/demo/": An SSL error has occurred and a secure connection to the server cannot be made.
	bundle exec pod keys set CrashlyticsAPIKey "-"
	bundle exec pod keys set TreasureDataAPIKey "-"
	bundle exec pod install
	# sh scripts/fabric.sh
	mkdir -p keys
	touch keys/fabric.apikey && echo "fabric.apikey" > keys/fabric.apikey
	touch keys/fabric.buildsecret && echo "fabric.buildsecret" > keys/fabric.buildsecret
