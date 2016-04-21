//
//  HistoryManager.swift
//  TryTVOS
//
//  Created by Ben on 20/04/2016.
//  Copyright © 2016 bcylin. All rights reserved.
//

import Foundation
import Freddy

struct HistoryManager {

  // MARK: - Private Properties

  private static var cache: NSURL? {
    guard
      let directory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first,
      let url = NSURL(string: directory)
    else {
      return nil
    }
    return url.URLByAppendingPathComponent("history.dat")
  }

  private static let savingQueue = dispatch_queue_create("io.github.bcylin.savingQueue", DISPATCH_QUEUE_SERIAL)

  // MARK: - Public Methods

  /// Returns the deserialized video history read from the cache directory.
  static var history: [JSON] {
    if let path = cache?.path, let records = NSArray(contentsOfFile: path) as? [NSData] {
      do {
        return try records.map { try JSON(data: $0) }
      } catch {
        Debug.print(error)
        return [JSON]()
      }
    } else {
      return [JSON]()
    }
  }

  /**
   Converts the video to JSON and saves an array of serialized video history to the cache directory in the background.

   - parameter video: A video object.
   */
  static func save(video video: Video) {
    dispatch_async(savingQueue) {
      guard let path = self.cache?.path else {
        return
      }
      Debug.print(path)

      let json = video.toJSON()
      var records = history

      // Keep the latest video at top.
      for (index, element) in self.history.enumerate() {
        if element["id"] == json["id"] {
          records.removeAtIndex(index)
          break
        }
      }
      records.insert(json, atIndex: 0)
      Debug.print("records.count =", records.count)

      do {
        let data = try records.map { try $0.serialize() } as NSArray
        data.writeToFile(path, atomically: true)
      } catch {
        Debug.print(error)
      }
    }
  }

}
