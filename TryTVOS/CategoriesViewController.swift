//
//  CategoriesViewController.swift
//  TryTVOS
//
//  Created by Ben on 22/03/2016.
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

class CategoriesViewController: UIViewController,
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout {

  private var categories = [Category]() {
    didSet {
      collectionView.reloadData()
    }
  }

  private(set) lazy var collectionView: UICollectionView = {
    let _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: Metrics.showcaseLayout)
    _collectionView.registerClass(CategoryCell.self, forCellWithReuseIdentifier: NSStringFromClass(CategoryCell.self))
    _collectionView.dataSource = self
    _collectionView.delegate = self
    return _collectionView
  }()

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    navigationItem.titleView = UIView()

    let divided = view.bounds.divide(300, fromEdge: .MinYEdge)
    collectionView.frame = divided.remainder
    collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]

    collectionView.layer.borderWidth = 1
    view.addSubview(collectionView)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    Alamofire.request(.GET, TrytvosKeys().baseAPIURL() + "categories.json")
      .responseJSON { [weak self] response in
        guard let data = response.data else { return }
        do {
          print(response.result.value)
          let json = try JSON(data: data)
          self?.categories = try json.array("categories").map(Category.init)
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

  // MARK: - UICollectionViewDataSource

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(CategoryCell.self), forIndexPath: indexPath)
    cell.layer.borderWidth = 1
    (cell as? CategoryCell)?.configure(withCategory: categories[indexPath.row])
    return cell
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let controller = CategoryViewController()
    navigationController?.pushViewController(controller, animated: true)
  }

}
