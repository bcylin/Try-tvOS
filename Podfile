source "https://github.com/CocoaPods/Specs.git"
source "https://github.com/bcylin/Specs.git"

platform :tvos, "9.0"
use_frameworks!
inhibit_all_warnings!

workspace "iCookTV"
project "iCookTV"

target :iCookTV do
  pod "Alamofire"
  pod "Crashlytics"
  pod "Fabric"
  pod "Freddy"
  pod "HCYoutubeParser"
  pod "Hue", git: "https://github.com/hyperoslo/Hue.git", commit: "89ae5e1"
  pod "R.swift"
  pod "Kingfisher"
  pod "TreasureData-tvOS-SDK", "0.1.14"

  target :iCookTVTests do
    pod "Nimble"
    pod "Quick"
  end
end


plugin "cocoapods-keys", {
  project: "iCookTV",
  keys: ["BaseAPIURL", "CrashlyticsAPIKey", "TreasureDataAPIKey"]
}


# Specify Swift version in the configs for all the pods installed.
post_install do |installer|
  installer.pods_project.targets.each do |target|
    next if target.name.start_with? "Pods-"

    config = "#{Dir.pwd}/Pods/Target Support Files/#{target.name}/#{target.name}.xcconfig"
    if not File.exists? config
      puts "Missing #{config}"
      next
    end

    puts "Adding SWIFT_VERSION=2.3 to #{config}"
    File.open(config, "a") { |file| file << "SWIFT_VERSION=2.3\n" }
    puts "Done"
  end
end
