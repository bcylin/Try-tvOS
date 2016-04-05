//
//  VideosViewController.swift
//  TryTVOS
//
//  Created by Ben on 15/03/2016.
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
import Alamofire
import Freddy
import Keys

class VideosViewController: BlurBackgroundViewController,
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout {

  private var categoryID = 0
  private var videos = [Video]() {
    didSet {
      collectionView.reloadData()
    }
  }

  private lazy var dropdownMenuView: MenuView = {
    let _menu = MenuView(frame: CGRect(x: 0, y: -140, width: self.view.bounds.width, height: 140))
    _menu.backgroundColor = UIColor.tvMenuBarColor()
    return _menu
  }()

  private let headerView = CategoryHeaderView()

  private(set) lazy var collectionView: UICollectionView = {
    let _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: Metrics.gridFlowLayout)
    _collectionView.registerClass(VideoCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCell.self))
    _collectionView.remembersLastFocusedIndexPath = true
    _collectionView.dataSource = self
    _collectionView.delegate = self
    return _collectionView
  }()

  // MARK: - Initialization

  convenience init(categoryID: Int, title: String? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.categoryID = categoryID
    self.title = title
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    navigationItem.titleView = UIView()
    headerView.accessoryLabel.text = title ?? "Category"

    let divided = view.bounds.divide(140, fromEdge: .MinYEdge)
    headerView.frame = divided.slice
    headerView.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
    collectionView.frame = divided.remainder
    collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]

    collectionView.layer.borderWidth = 1
    view.backgroundColor = UIColor.tvBackgroundColor()
    view.addSubview(headerView)
    view.addSubview(collectionView)
    view.addSubview(dropdownMenuView)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if categoryID < 0 {
      // TODO: handle error
      return
    }

    Alamofire.request(.GET, TrytvosKeys().baseAPIURL() + "categories/\(categoryID)/videos.json")
      .responseJSON { [weak self] response in
        guard let data = response.data else { return }
        do {
          let json = try JSON(data: data)
          self?.videos = try json.array("videos").map(Video.init)
        } catch {
          #if DEBUG
            print(error)
          #endif
        }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  // MARK: - UIFocusEnvironment

  override var preferredFocusedView: UIView? {
    return collectionView
  }

  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if context.nextFocusedView == dropdownMenuView.button {
      let revealedFrame = CGRect(origin: CGPoint.zero, size: dropdownMenuView.frame.size)
      coordinator.addCoordinatedAnimations({
        self.dropdownMenuView.frame = revealedFrame
      }, completion: nil)
    }

    if context.previouslyFocusedView == dropdownMenuView.button {
      let hiddenFrame = dropdownMenuView.frame.offsetBy(dx: 0, dy: -dropdownMenuView.frame.height)
      coordinator.addCoordinatedAnimations({
        self.dropdownMenuView.frame = hiddenFrame
      }, completion: nil)
    }
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videos.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(VideoCell.self), forIndexPath: indexPath)
    (cell as? VideoCell)?.configure(withVideo: videos[indexPath.row])
    return cell
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as? VideoCell
    let controller = VideoPlayerController(video: videos[indexPath.row], coverImage: cell?.imageView.image)
    presentViewController(controller, animated: true) {
      controller.player?.play()
    }
  }

  func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if let cover = (context.nextFocusedView as? VideoCell)?.imageView.image {
      self.backgroundImage = cover
    }
  }

}
