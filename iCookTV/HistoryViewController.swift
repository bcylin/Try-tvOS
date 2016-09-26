//
//  HistoryViewController.swift
//  TryTVOS
//
//  Created by Ben on 21/04/2016.
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

class HistoryViewController: VideosViewController {

  // MARK: - UIViewController

  override var title: String? {
    get {
      return R.string.localizable.history()
    }
    set {}
  }

  override func loadView() {
    super.loadView()
    dropdownMenuView.button.setTitle(R.string.localizable.home(), for: .normal)
    dropdownMenuView.button.addTarget(self, action: .backToHome, for: .primaryActionTriggered)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setOverlayViewHidden(false, animated: false)
    isLoading = true
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
      do {
        let history = try HistoryManager.history.map(Video.init)
        DispatchQueue.main.sync {
          self.dataSource.append(history, toCollectionView: self.collectionView)
          self.setOverlayViewHidden(self.dataSource.numberOfItems > 0, animated: true)
          self.isLoading = false
        }
      } catch {
        Tracker.track(error)
        // Remove the malformed cache.
        HistoryManager.deleteCache() { _ in
          self.isLoading = false
        }
      }
      Tracker.track(PageView(name: "history", details: [
        TrackableKey.numberOfItems: self.dataSource.numberOfItems
      ]))
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if dataSource.numberOfItems > 0 {
      collectionView.reloadData()
    }
  }

  // MARK: - VideosViewController

  override var pagingTracking: Event? {
    return nil
  }

  // MARK: - UICollectionViewDelegate

  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // History doesn't need pagination.
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, didSelectItemAt: indexPath)
    // Reorder current displayed contents after the video player is presented.
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
      self.dataSource.moveItem(atIndexPathToTop: indexPath, inCollectionView: collectionView)
    }
  }

  // MARK: - OverlayEnabled

  private lazy var emptyStateOverlay: UIView = {
    let _empty = EmptyStateView()
    _empty.textLabel.text = R.string.localizable.noHistoryFound()
    return _empty
  }()

  override var overlayView: UIView {
    return emptyStateOverlay
  }

  // MARK: - Trackable

  override var pageView: PageView? {
    // Track History PV when the number of items is retrived.
    return nil
  }

  // MARK: - UIResponder Callbacks

  @objc fileprivate func backToHome(_ sender: UIButton) {
    _ = navigationController?.popToRootViewController(animated: true)
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let backToHome = #selector(HistoryViewController.backToHome(_:))
}
