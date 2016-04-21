# Try-tvOS

[![Build Status](https://travis-ci.org/bcylin/Try-tvOS.svg)](https://travis-ci.org/bcylin/Try-tvOS)

A demo tvOS app that plays YouTube videos.

## Setup

* Set up dependencies:

  ```
bundle install
bundle exec pod install
```

* `pod install` will prompt for `BaseAPIURL`, which is required to run the app:

  ```
CocoaPods-Keys has detected a keys mismatch for your setup.
What is the key for BaseAPIURL
>
```

  > API details are hidden due to proprietary reasons. Any API output that contains the matched keys will suffice.

## JSON API 1.0 Response

The response of `categories`:

```json
{
  "data": [
    {
      "id": "1",
      "attributes": {
        "name": "",
        "cover-urls": [
          "https://imag.es/1.png",
          "https://imag.es/2.png",
          "https://imag.es/3.png",
          "https://imag.es/4.png"
        ]
      }
    }
  ]
}
```

The response of `categories/:id/videos`:

```json
{
  "data": [
    {
      "id": "1",
      "attributes": {
        "title": "",
        "subtitle": "",
        "description": "",
        "length": 0.0,
        "embed-url": "https://www.youtube.com/watch?v=",
        "cover-url": "https://imag.es/400x300.png"
      }
    }
  ]
}
```

## License

This demo app is released under the MIT license. See [LICENSE](https://github.com/bcylin/Try-tvOS/blob/master/LICENSE) for more info.
