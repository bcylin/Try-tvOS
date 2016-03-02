# Try-tvOS

A demo tvOS app that plays YouTube videos.

## Setup

* Set up dependencies:

  ```
bundle install
pod install
```

* `pod install` will prompt for `BaseAPIURL`, `VideosAPIPath` and `FeaturesAPIPath`, which are required to run the app:

  ```
CocoaPods-Keys has detected a keys mismatch for your setup.
What is the key for BaseAPIURL
>
```

  > API details are hidden due to proprietary reasons. Any API output that contains the matched keys will suffice.

## API Response

The `Video` matches a JSON structure as follows:

```
{
  id
  title
  description
  embed_url // YouTube url
  image {
    url
    medium {
      url
    }
    thumb {
      url
    }
  }
}
```

## License

This demo app is released under the MIT license. See [LICENSE](https://github.com/bcylin/Try-tvOS/blob/master/LICENSE) for more info.
