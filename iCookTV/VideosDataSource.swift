//
//  VideosDataSource.swift
//  TryTVOS
//
//  Created by Ben on 14/08/2016.
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

class VideosDataSource: NSObject, SourceType {

  typealias DataType = Video

  var currentPage: Int {
    return Int(numberOfItems / self.dynamicType.pageSize)
  }

  static let pageSize = 20

  private let title: String
  private var videos = [Video]()

  // MARK: - Initialization

  init(title: String) {
    self.title = title
  }

  // MARK: - SourceType

  subscript(index: Int) -> Video {
    return videos[index]
  }

  var numberOfItems: Int {
    return videos.count
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoCell.self), forIndexPath: indexPath)
    (cell as? VideoCell)?.configure(withVideo: videos[indexPath.row])
    return cell
  }

  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
        UICollectionElementKindSectionHeader,
        withReuseIdentifier: String(CategoryHeaderView.self),
        forIndexPath: indexPath
      )
      (headerView as? CategoryHeaderView)?.accessoryLabel.text = title ?? "Category"
      return headerView
    }

    return UICollectionReusableView()
  }

  // MARK: - Public Methods

  func append(videos: [Video], toCollectionView collectionView: UICollectionView) {
    self.videos += videos
    collectionView.reloadData()
  }

  func bringVideo(atIndexPath indexPath: NSIndexPath, toTopOfCollectionView collectionView: UICollectionView) {
    let target = videos[indexPath.row]
    var newOrder = videos
    newOrder.removeAtIndex(indexPath.row)
    newOrder.insert(target, atIndex: 0)
    videos = newOrder
    collectionView.reloadData()
  }

}
