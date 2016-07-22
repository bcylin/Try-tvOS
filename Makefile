pod-install:
	bundle exec pod install --no-repo-update
	xcproj touch iCookTV.xcodeproj

coverage:
	bundle exec slather coverage -s --input-format profdata --scheme iCookTV --workspace iCookTV.xcworkspace iCookTV.xcodeproj
