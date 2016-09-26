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
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout,
  OverlayEnabled,
  Trackable {

  private(set) lazy var dataSource: VideosDataSource = {
    VideosDataSource(title: self.title ?? "")
  }()

  var pagingTracking: Event? {
    return Event(name: "Fetched Page", details: [
      TrackableKey.categoryID: categoryID as AnyObject,
      TrackableKey.categoryTitle: title as AnyObject? ?? "" as AnyObject,
      TrackableKey.page: String(dataSource.currentPage) as AnyObject
    ])
  }

  // MARK: - Private Properties

  private var categoryID = ""

  private(set) lazy var dropdownMenuView: MenuView = {
    let _menu = MenuView(frame: CGRect(x: 0, y: -140, width: self.view.bounds.width, height: 140))
    _menu.backgroundColor = UIColor.tvMenuBarColor()
    return _menu
  }()

  private(set) lazy var collectionView: UICollectionView = {
    let _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: Metrics.gridFlowLayout)
    _collectionView.register(VideoCell.self, forCellWithReuseIdentifier: NSStringFromClass(VideoCell.self))
    _collectionView.register(
      CategoryHeaderView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: String(describing: CategoryHeaderView.self)
    )
    _collectionView.remembersLastFocusedIndexPath = true
    _collectionView.dataSource = self.dataSource
    _collectionView.delegate = self
    return _collectionView
  }()

  private weak var currentRequest: Request?
  private let paginationQueue = DispatchQueue(label: "io.github.bcylin.paginationQueue", attributes: [])
  private var hasNextPage = true

  // MARK: - Initialization

  convenience init(categoryID: String, title: String? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.categoryID = categoryID
    self.title = title
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.tvBackgroundColor()
    collectionView.frame = view.bounds
    view.addSubview(collectionView)
    view.addSubview(dropdownMenuView)

    dropdownMenuView.button.setTitle(R.string.localizable.history(), for: .normal)
    dropdownMenuView.button.addTarget(self, action: .showHistory, for: .primaryActionTriggered)

    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: CategoryHeaderView.requiredHeight)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if categoryID.isEmpty {
      setOverlayViewHidden(false, animated: true)
      return
    }
    fetchNextPage()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard let stack = navigationController?.viewControllers else {
      return
    }
    // Track the event when popped off the navigation stack.
    if let event = pagingTracking, !stack.contains(self) {
      Tracker.track(event)
    }
  }

  // MARK: - UIFocusEnvironment

  override var preferredFocusedView: UIView? {
    return collectionView
  }

  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if context.nextFocusedView == dropdownMenuView.button {
      let revealedFrame = CGRect(origin: CGPoint.zero, size: dropdownMenuView.frame.size)
      coordinator.addCoordinatedAnimations({
        self.dropdownMenuView.frame = revealedFrame
      }, completion: nil)
    } else if context.previouslyFocusedView == dropdownMenuView.button {
      let hiddenFrame = dropdownMenuView.frame.offsetBy(dx: 0, dy: -dropdownMenuView.frame.height)
      coordinator.addCoordinatedAnimations({
        self.dropdownMenuView.frame = hiddenFrame
      }, completion: nil)
    }
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.row == dataSource.numberOfItems - 1 && hasNextPage {
      fetchNextPage()
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let video = dataSource[indexPath.row]
    let cell = collectionView.cellForItem(at: indexPath) as? VideoCell

    let controller = VideoPlayerController(video: video, coverImage: cell?.imageView.image)
    navigationController?.pushViewController(controller, animated: true)
    HistoryManager.save(video: video)
  }

  func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if let cover = (context.nextFocusedView as? VideoCell)?.imageView.image {
      self.backgroundImage = cover
    }
  }

  // MARK: - OverlayEnabled

  private lazy var emptyStateOverlay: UIView = { EmptyStateView() }()

  var overlayView: UIView {
    return emptyStateOverlay
  }

  func containerViewForOverlayView(_ overlayView: UIView) -> UIView {
    return view
  }

  func constraintsForOverlayView(_ overlayView: UIView) -> [NSLayoutConstraint] {
    return [
      overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
  }

  // MARK: - Trackable

  var pageView: PageView? {
    return PageView(name: "Videos", details: [
      TrackableKey.categoryID: categoryID as AnyObject,
      TrackableKey.categoryTitle: title as AnyObject? ?? "" as AnyObject
    ])
  }

  // MARK: - UIResponder Callbacks

  @objc fileprivate func showHistory(_ sender: UIButton) {
    navigationController?.pushViewController(HistoryViewController(), animated: true)
  }

  // MARK: - Private Methods

  private func fetchNextPage() {
    if let _ = currentRequest {
      return
    }

    isLoading = (dataSource.numberOfItems == 0)

    let url = iCookTVKeys.baseAPIURL + "categories/\(categoryID)/videos.json"
    let parameters = [
      "page[size]": type(of: dataSource).pageSize,
      "page[number]": dataSource.currentPage + 1
    ]

    currentRequest = Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
      self?.isLoading = false

      guard let data = response.data, response.result.error == nil else {
        self?.showAlert(response.result.error)
        return
      }

      guard let
        collectionView = self?.collectionView,
        let pagination = self?.paginationQueue
      else {
        return
      }

      pagination.async {
        do {
          let json = try JSON(data: data)
          let videos = try json.getArray(at: "data").map(Video.init)

          DispatchQueue.main.sync {
            self?.hasNextPage = json["links"]?["next"] != nil
            self?.dataSource.append(videos, toCollectionView: collectionView)
            if let numberOfItems = self?.dataSource.numberOfItems {
              self?.setOverlayViewHidden(numberOfItems > 0, animated: true)
            } else {
              self?.setOverlayViewHidden(false, animated: true)
            }
          }
        } catch {
          DispatchQueue.main.sync {
            self?.showAlert(error, retry: self?.fetchNextPage)
          }
        }
      }
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let showHistory = #selector(VideosViewController.showHistory(_:))
}
