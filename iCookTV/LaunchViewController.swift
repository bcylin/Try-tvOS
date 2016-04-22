//
//  LaunchViewController.swift
//  TryTVOS
//
//  Created by Ben on 10/04/2016.
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

class LaunchViewController: UIViewController {

  private lazy var loadingImageView: UIImageView = {
    let _imageView = UIImageView()
    _imageView.image = UIImage(named: "icook-tv-cat")
    _imageView.contentMode = .ScaleAspectFill
    return _imageView
  }()

  private lazy var taglineLabel: UILabel = {
    let _label = UILabel()
    _label.font = UIFont.tvFontForTagline()
    _label.textColor = UIColor.tvTaglineColor()
    _label.text = "Tagline".localizedString
    return _label
  }()

  override func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.tvBackgroundColor()
    view.addSubview(loadingImageView)
    view.addSubview(taglineLabel)

    loadingImageView.translatesAutoresizingMaskIntoConstraints = false
    taglineLabel.translatesAutoresizingMaskIntoConstraints = false

    loadingImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    loadingImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -45).active = true

    taglineLabel.topAnchor.constraintEqualToAnchor(loadingImageView.bottomAnchor, constant: 50).active = true
    taglineLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchCategories()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  // MARK: - Private Methods

  private func fetchCategories() {
    Alamofire.request(.GET, iCookTVKeys.baseAPIURL + "categories.json").responseJSON { [weak self] response in
      guard let data = response.data where response.result.error == nil else {
        self?.showAlert(response.result.error)
        return
      }

      do {
        Debug.print(response.result.value)
        let json = try JSON(data: data)
        let categories = try json.array("data").map(Category.init)
        self?.navigationController?.setViewControllers([CategoriesViewController(categories: categories)], animated: true)
      } catch {
        self?.showAlert(error) { _ in
          self?.fetchCategories()
        }
      }
    }
  }

}
