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

  static let numberOfColumns = 4

  static let defaultFlowLayout: UICollectionViewFlowLayout = {
    let _flowLayout = UICollectionViewFlowLayout()
    _flowLayout.sectionInset = UIEdgeInsets(top: 75, left: 100, bottom: 75, right: 100)
    _flowLayout.minimumInteritemSpacing = 75
    _flowLayout.minimumLineSpacing = 75

    var width = UIScreen.mainScreen().bounds.width
    width -= _flowLayout.sectionInset.left
    width -= _flowLayout.sectionInset.right
    width -= _flowLayout.minimumInteritemSpacing * CGFloat(numberOfColumns - 1)
    width /= CGFloat(numberOfColumns)
    _flowLayout.itemSize = CGSize(width: width, height: width * 9 / 16)

    return _flowLayout
  }()

  private var videos = [Video]() {
    didSet {
      collectionView?.reloadData()
    }
  }

  // MARK: - Initialization

  convenience init() {
    self.init(collectionViewLayout: self.dynamicType.defaultFlowLayout)
    title = "Videos"
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    collectionView?.registerClass(VideoCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCell.self))
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let keys = TrytvosKeys()
    #if DEBUG
    print(keys.videoAPIPath())
    #endif

    Alamofire.request(.GET, keys.videoAPIPath())
      .responseJSON { response in
        guard let data = response.data else { return }
        do {
          let json = try JSON(data: data)
          self.videos = try json.array().map(Video.init)
        } catch {
          #if DEBUG
          print(error)
          #endif
        }
    }
  }

  // MARK: - UICollectionViewDataSource

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoCell.self), forIndexPath: indexPath)
    return cell
  }

}
