source "https://github.com/CocoaPods/Specs.git"

platform :tvos, "9.0"
use_frameworks!
inhibit_all_warnings!

workspace "TryTVOS"
xcodeproj "TryTVOS"

pod "Alamofire"
pod "Freddy"
pod "HCYoutubeParser"
pod "Hue", git: "git@github.com:bcylin/Hue.git", branch: "support-tvos"
pod "Kingfisher"

plugin "cocoapods-keys", {
  project: "TryTVOS",
  keys: ["BaseAPIURL"]
}
