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
import HCYoutubeParser
import Keys

class VideosViewController: UICollectionViewController {

  private static let horizontalFlowLayout: UICollectionViewFlowLayout = {
    let _horizontal = UICollectionViewFlowLayout()
    _horizontal.scrollDirection = .Horizontal
    _horizontal.sectionInset = UIEdgeInsets(top: 0, left: 75, bottom: 0, right: 75)
    _horizontal.minimumInteritemSpacing = 75
    _horizontal.minimumLineSpacing = 0
    _horizontal.itemSize = CGSize(width: 300, height: 300)
    return _horizontal
  }()

  private static let verticalFlowLayout: UICollectionViewFlowLayout = {
    let _vertical = UICollectionViewFlowLayout()
    _vertical.scrollDirection = .Vertical
    _vertical.sectionInset = UIEdgeInsetsZero
    _vertical.minimumInteritemSpacing = 75
    _vertical.minimumLineSpacing = 75
    _vertical.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 300)
    return _vertical
  }()

  private var videos = [Video]() {
    didSet {
      collectionView?.reloadData()
    }
  }

  // MARK: - Initialization

  convenience init() {
    self.init(collectionViewLayout: self.dynamicType.verticalFlowLayout)
    title = "Videos"
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    collectionView?.registerClass(VideoCategoryCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCategoryCell.self))
    collectionView?.registerClass(VideoCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCell.self))
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
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoCategoryCell.self), forIndexPath: indexPath)
    cell.layer.borderWidth = 1
    return cell
  }

  // MARK: - UICollectionViewDelegate

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard
      let youtube = NSURL(string: videos[indexPath.row].youtube),
      let medium = HCYoutubeParser.h264videosWithYoutubeURL(youtube)?["medium"] as? String,
      let url = NSURL(string: medium)
      else {
        return
    }

    let player = VideoPlayerController(url: url)
    navigationController?.pushViewController(player, animated: true)
  }

}
