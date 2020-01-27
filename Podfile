source "https://github.com/CocoaPods/Specs.git"

platform :tvos, "10.0"
use_frameworks!
inhibit_all_warnings!

workspace "iCookTV"
project "iCookTV"

target :iCookTV do
  pod "Alamofire", git: "https://github.com/Alamofire/Alamofire.git", tag: "4.8.2"
  pod "Crashlytics"
  pod "Fabric"
  pod "HCYoutubeParser"
  pod "Hue", git: "https://github.com/zenangst/Hue.git", tag: "5.0.0"
  pod "Kingfisher", git: "https://github.com/onevcat/Kingfisher.git", tag: "5.7.0"
  pod "TreasureData-iOS-SDK", "0.1.15"

  target :iCookTVTests do
    pod "SwiftLint", podspec: "https://raw.githubusercontent.com/CocoaPods/Specs/master/Specs/4/0/1/SwiftLint/0.34.0/SwiftLint.podspec.json"
  end
end


plugin "cocoapods-keys", {
  project: "iCookTV",
  keys: ["BaseAPIURL", "CrashlyticsAPIKey", "TreasureDataAPIKey"]
}

