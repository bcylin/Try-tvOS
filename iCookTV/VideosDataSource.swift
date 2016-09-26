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

class VideosDataSource: DataSource<VideosCollection> {

  var currentPage: Int {
    return Int(numberOfItems / type(of: self).pageSize)
  }

  static let pageSize = 20

  private let title: String

  // MARK: - Initialization

  init(title: String) {
    self.title = title
    super.init(dataCollection: VideosCollection())
  }

  // MARK: - UICollectionViewDataSource

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(VideoCell.self), for: indexPath)
    (cell as? VideoCell)?.configure(withVideo: dataCollection[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionElementKindSectionHeader,
        withReuseIdentifier: String(describing: CategoryHeaderView.self),
        for: indexPath
      )
      (headerView as? CategoryHeaderView)?.accessoryLabel.text = title ?? "Category"
      return headerView
    }

    return UICollectionReusableView()
  }

}
