//
//  VideoRowViewController.swift
//  TryTVOS
//
//  Created by Ben on 29/02/2016.
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

class VideoRowViewController: UIViewController, UICollectionViewDataSource {

  private(set) var videos = [Video]()

  private(set) lazy var collectionView: VideoRowCollectionView = {
    let _collectionView = VideoRowCollectionView(frame: CGRect.zero, collectionViewLayout: Metrics.horizontalFlowLayout)
    _collectionView.clipsToBounds = false
    _collectionView.registerClass(VideoCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCell.self))
    _collectionView.dataSource = self
    return _collectionView
  }()

  // MARK: - Initialization

  convenience init(name: String, videos: [Video]) {
    self.init(nibName: nil, bundle: nil)
    self.videos = videos
    title = name
  }

  deinit {
    collectionView.dataSource = nil
    collectionView.delegate = nil
  }

  // MARK: - UICollectionViewDataSource

  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoCell.self), forIndexPath: indexPath)
    (cell as? VideoCell)?.configure(withVideo: videos[indexPath.row])
    return cell
  }

}
