//
//  VideosViewController.swift
//  TryTVOS
//
//  Created by Ben on 16/09/2015.
//  Copyright © 2015 bcylin.
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
import Alamofire
import Freddy
import Keys

class VideosViewController: UICollectionViewController {

  private var videoRows = [VideoRowViewController]() {
    didSet {
      collectionView?.reloadData()
    }
  }

  // MARK: - Initialization

  convenience init() {
    self.init(collectionViewLayout: Metrics.verticalFlowLayout)
    title = "Videos"
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    collectionView?.registerClass(VideoRowContainerCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoRowContainerCell.self))
    collectionView?.registerClass(VideoRowTitleView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: NSStringFromClass(VideoRowTitleView.self)
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let keys = TrytvosKeys()
    #if DEBUG
    print(keys.videoAPIPath())
    #endif

    Alamofire.request(.GET, keys.baseAPIURL() + keys.featuresAPIPath())
      .responseJSON { response in
        guard let data = response.data else { return }
        do {
          let json = try JSON(data: data)
          let features = VideoRowViewController(name: "Features", videos: try json.array("videos").map(Video.init))
          let indexSet = NSIndexSet(index: self.videoRows.count)
          self.videoRows.append(features)
          self.collectionView?.reloadSections(indexSet)
        } catch {
          #if DEBUG
          print(error)
          #endif
        }
    }

    Alamofire.request(.GET, keys.baseAPIURL() + keys.videosAPIPath())
      .responseJSON { response in
        guard let data = response.data else { return }
        do {
          let json = try JSON(data: data)
          let videos = VideoRowViewController(name: "Videos", videos: try json.array().map(Video.init))
          let indexSet = NSIndexSet(index: self.videoRows.count)
          self.videoRows.append(videos)
          self.collectionView?.reloadSections(indexSet)
        } catch {
          #if DEBUG
            print(error)
          #endif
        }
    }
  }

  // MARK: - UICollectionViewDataSource

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return videoRows.count
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoRowContainerCell.self), forIndexPath: indexPath)
    let rowCollectionView = videoRows[indexPath.section].collectionView
    rowCollectionView.delegate = self
    (cell as? VideoRowContainerCell)?.configure(withEmbeddedCollectionView: rowCollectionView)
    return cell
  }

  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(VideoRowTitleView.self), forIndexPath: indexPath)
    let row = videoRows[indexPath.section]
    (header as? VideoRowTitleView)?.textLabel.text = row.title
    return header
  }

  // MARK: - UICollectionViewDelegate

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard let section = sectionForRowCellectionView(collectionView as? VideoRowCollectionView) else { return }
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as? VideoCell
    let controller = VideoPlayerController(video: videoRows[section].videos[indexPath.row], coverImage: cell?.imageView.image)
    presentViewController(controller, animated: true) {
      controller.player?.play()
    }
  }

  override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Focus VideoCells inside VideoRowCollectionView instead of VideoRowContainerCell in self.collectionView.
    return collectionView is VideoRowCollectionView
  }

  // MARK: - Private Methods

  private func sectionForRowCellectionView(collectionView: VideoRowCollectionView?) -> Int? {
    if let rowCell = collectionView?.rowContainerCell, let section = self.collectionView?.indexPathForCell(rowCell)?.section {
      return section
    }
    return nil
  }

}
