//
//  VideoPlayerController.swift
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

import UIKit
import AVKit

class VideoPlayerController: AVPlayerViewController {

  convenience init(url: NSURL) {
    self.init(nibName: nil, bundle: nil)
    let playerItem = AVPlayerItem(URL: url)
    player = AVPlayer(playerItem: playerItem)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: Selector("handlePlayerItemDidPlayToEndTime:"),
      name: AVPlayerItemDidPlayToEndTimeNotification,
      object: playerItem
    )
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self,
      name: AVPlayerItemDidPlayToEndTimeNotification,
      object: nil)
  }

  // MARK: - UIViewController

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    player?.play()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    player?.pause()
  }

  // MARK: - NSNotification Callbacks

  @IBAction private func handlePlayerItemDidPlayToEndTime(notification: NSNotification) {
    navigationController?.popViewControllerAnimated(true)
  }

}
