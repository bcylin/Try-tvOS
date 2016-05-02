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

class VideoPlayerController: AVPlayerViewController, Trackable {

  private var video: Video?
  private var coverImage: UIImage?

  /// An activity indicator displayed before the player item is ready.
  private lazy var loadingIndicator: UIActivityIndicatorView = {
    let _indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    _indicator.hidesWhenStopped = true
    return _indicator
  }()

  // MARK: - Initialization

  convenience init(video: Video, coverImage image: UIImage? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.video = video
    self.coverImage = image
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(
      self,
      name: AVPlayerItemDidPlayToEndTimeNotification,
      object: nil
    )
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    if let contentView = contentOverlayView {
      contentView.addSubview(loadingIndicator)
      loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
      // AVPlayerViewController's own indicator has a 5 pt offset from the center.
      loadingIndicator.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor, constant: -5).active = true
      loadingIndicator.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadingIndicator.startAnimating()
    video?.convertToPlayerItemWithCover(coverImage) { [weak self] in
      self?.setPlayerItem($0)
    }
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    player?.pause()
  }

  // MARK: - Trackable

  var pageView: PageView? {
    return PageView(name: "Player", details: [
      "Video ID": video?.id ?? "",
      "Video Title": video?.title ?? ""
    ])
  }

  // MARK: - NSNotification Callbacks

  @objc private func handlePlayerItemDidPlayToEndTime(notification: NSNotification) {
    dismiss()
  }

  // MARK: - Private Methods

  private func dismiss() {
    if let navigation = navigationController {
      navigation.popViewControllerAnimated(true)
    } else if let presenter = presentingViewController {
      presenter.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  private func setPlayerItem(playerItem: AVPlayerItem?) {
    loadingIndicator.stopAnimating()

    guard let playerItem = playerItem else {
      let message = "There's something wrong with this video.".localizedString +
                    "\nContact hi@icook.tw for support.".localizedString
      let alert = UIAlertController(title: "Error\n".localizedString, message: message, preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK".localizedString, style: .Default) { [weak self] _ in
        self?.dismiss()
      })
      presentViewController(alert, animated: true, completion: nil)
      return
    }

    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: #selector(handlePlayerItemDidPlayToEndTime(_:)),
      name: AVPlayerItemDidPlayToEndTimeNotification,
      object: playerItem
    )

    player = AVPlayer(playerItem: playerItem)
    player?.play()
  }

}
