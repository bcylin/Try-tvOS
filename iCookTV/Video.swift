//
//  Video.swift
//  TryTVOS
//
//  Created by Ben on 19/02/2016.
//  Copyright © 2016 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import AVKit
import Foundation
import Freddy
import HCYoutubeParser

struct Video: JSONDecodable, JSONEncodable {

  let id: String
  let title: String
  let subtitle: String?
  let description: String?
  let length: Int
  let youtube: String
  let cover: String

  var coverURL: NSURL? {
    return NSURL(string: cover)
  }

  var timestamp: String {
    let seconds = length % 60
    let minutes = (length / 60) % 60
    let hours = length / 3600
    return (hours > 0 ? "\(hours):" : "") + String(format: "%d:%02d", minutes, seconds)
  }

  // MARK: - JSONDecodable

  init(json value: JSON) throws {
    id = try value.string("id")
    title = try value.string("attributes", "title")
    subtitle = try value.string("attributes", "subtitle", ifNull: true)
    description = try value.string("attributes", "description", ifNull: true)
    length = try value.int("attributes", "length", or: 0)
    youtube = try value.string("attributes", "embed-url")
    cover = try value.string("attributes", "cover-url")
  }

  // MARK: - JSONEncodable

  func toJSON() -> JSON {
    var attributes: [String: JSON] = [
      "title": .String(title),
      "embed-url": .String(youtube),
      "cover-url": .String(cover),
      "length": .Int(length)
    ]

    if let subtitle = subtitle {
      attributes["subtitle"] = .String(subtitle)
    }
    if let description = description {
      attributes["description"] = .String(description)
    }

    let json: [String: JSON] = [
      "id": .String(id),
      "attributes": .Dictionary(attributes)
    ]

    return .Dictionary(json)
  }

  // MARK: - Helpers

  var playerItemURL: NSURL? {
    guard
      let youtubeURL = NSURL(string: youtube),
      let medium = HCYoutubeParser.h264videosWithYoutubeURL(youtubeURL)?["hd720"] as? String
      else {
        return nil
    }
    return NSURL(string: medium)
  }

  var titleMetaData: AVMetadataItem {
    let _title = AVMutableMetadataItem()
    _title.key = AVMetadataCommonKeyTitle
    _title.keySpace = AVMetadataKeySpaceCommon
    _title.locale = NSLocale.currentLocale()
    _title.value = title
    return _title
  }

  var descriptionMetaData: AVMetadataItem {
    let _description = AVMutableMetadataItem()
    _description.key = AVMetadataCommonKeyDescription
    _description.keySpace = AVMetadataKeySpaceCommon
    _description.locale = NSLocale.currentLocale()
    _description.value = (subtitle == nil ? "" : subtitle! + "\n") + (description ?? "")
    return _description
  }

}
