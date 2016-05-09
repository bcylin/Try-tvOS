//
//  Tracker.swift
//  iCookTV
//
//  Created by Ben on 28/04/2016.
//  Copyright © 2016 Polydice, Inc.
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

import Foundation
import Crashlytics
import TreasureData_tvOS_SDK

enum Tracker {

  private static let name = "icook_tvos"

  static func track(pageView: PageView) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      Debug.print(pageView)
      Answers.logCustomEventWithName(pageView.name, customAttributes: pageView.details)
      TreasureData.sharedInstance().addEvent(pageView.attributes, database: name, table: "screens")
    }
  }

  static func track(event: Event) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      Debug.print(event)
      Answers.logCustomEventWithName(event.name, customAttributes: event.details)
      TreasureData.sharedInstance().addEvent(event.attributes, database: name, table: "events")
    }
  }

  static func track(error: ErrorType?) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      let description = (error as? NSError)?.localizedDescription ?? "\(error)"
      Debug.print(description)
      Answers.logCustomEventWithName("Error", customAttributes: ["Description": description])
      TreasureData.sharedInstance().addEvent(["description": description], database: name, table: "errors")
    }
  }

}
