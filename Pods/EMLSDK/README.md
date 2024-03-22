Add the Spec Repository

`pod repo add gitlab-eml_sdk-cocoapods-repo https://gitlab.com/EML_SDK/CocoaPods/repo`

Bulid the SDK

`cd eml-ios-sdk/EMLiOSSDK`

`./build.sh`

Copy the framework file from release-universal to the repo cloned from here (https://gitlab.com/EML_SDK/CocoaPods/emlsdk).

Update the .podspec file from this repo, to include the new version number

Zip the Framework and podspec file together

`zip EMLSDK.zip EMLSDK.podspec EMLiOSSDK.framework`

Commit and push these changes to this repo

Tag this repo with the version number of the repo (must match .podspec file)

Validate the Pod

`pod spec lint`

Push the Pod to the Spec Repo

`pod repo push gitlab-eml_sdk-cocoapods-repo EMLSDK.podspec`
