//
//  HistoryViewController.swift
//  TryTVOS
//
//  Created by Ben on 21/04/2016.
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

import UIKit

class HistoryViewController: VideosViewController {

  // MARK: - UIViewController

  override var title: String? {
    get {
      return "History".localizedString
    }
    set {}
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    isLoading = true
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      do {
        let history = try HistoryManager.history.map(Video.init)
        dispatch_async(dispatch_get_main_queue()) {
          self.videos = history
          self.isLoading = false
        }
      } catch {
        Debug.print(error)
      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if !videos.isEmpty {
      collectionView.reloadData()
    }
  }

  // MARK: - VideosViewController

  override func saveToHistory(video: Video, atIndex index: Int) {
    super.saveToHistory(video, atIndex: index)
    // Reorder current displayed contents
    var reordered = self.videos
    reordered.removeAtIndex(index)
    reordered.insert(video, atIndex: 0)
    self.videos = reordered
  }

}
