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

  let id: Int
  let title: String
  let subtitle: String?
  let description: String?
  let youtube: String
  let cover: Cover?

  // MARK: - JSONDecodable

  init(json value: JSON) throws {
    id = try value.int("id")
    title = try value.string("title")
    subtitle = try value.string("subtitle", ifNull: true)
    description = try value.string("description", ifNull: true)
    youtube = try value.string("youtube_url")
    cover = try value["cover"].map(Cover.init)
  }

  // MARK: - JSONEncodable

  func toJSON() -> JSON {
    var json: [String: JSON] = [
      "id": .Int(id),
      "title": .String(title),
      "youtube_url": .String(youtube),
    ]

    if let subtitle = subtitle {
      json["subtitle"] = .String(subtitle)
    }
    if let description = description {
      json["description"] = .String(description)
    }
    if let cover = cover {
      json["cover"] = cover.toJSON()
    }

    return .Dictionary(json)
  }

  // MARK: - Helpers

  var playerItemURL: NSURL? {
    guard
      let youtubeURL = NSURL(string: youtube),
      let medium = HCYoutubeParser.h264videosWithYoutubeURL(youtubeURL)?["medium"] as? String
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


////////////////////////////////////////////////////////////////////////////////


struct Cover: JSONDecodable, JSONEncodable {

  let large: String?
  let small: String?

  init(json value: JSON) throws {
    large = try value.string("large_url", ifNotFound: true)
    small = try value.string("small_url", ifNotFound: true)
  }

  // MARK: - JSONEncodable

  func toJSON() -> JSON {
    var json =  [String: JSON]()

    if let large = large {
      json["large_url"] = .String(large)
    }
    if let small = small {
      json["small_url"] = .String(small)
    }

    return .Dictionary(json)
  }

}
