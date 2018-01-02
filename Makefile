bootstrap:
	brew tap homebrew/bundle
	brew bundle
	bundle install
	# pod install
	bundle exec pod keys set BaseAPIURL "https://polydice.com/iCook-tvOS/demo/"
	bundle exec pod keys set CrashlyticsAPIKey "-"
	bundle exec pod keys set TreasureDataAPIKey "-"
	bundle exec pod install
	# sh scripts/fabric.sh
	echo "fabric.apikey" > keys/fabric.apikey
	echo "fabric.buildsecret" > keys/fabric.buildsecret
